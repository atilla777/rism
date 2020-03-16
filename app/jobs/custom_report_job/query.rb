class CustomReportJob::Query
  def initialize(statement, variables_from_custom_report_result = {})
    @statement = statement
    @variables_arr = variables_arr
    @variables_hash = variables_hash
    @variables_from_custom_report_result = variables_from_custom_report_result
  end

  def run
    run_in_trasaction do
      @result = if @variables_arr.empty? # Sql query without variables (for example - without {name})
        ActiveRecord::Base.connection.exec_query(@statement)
      else
        ActiveRecord::Base.connection
          .exec_query(
            transformed_statement,
            'SQL',
            bindings
          )
      end
    end
    @result
  rescue ActiveRecord::ActiveRecordError => error
    @result = error
    @result
  end

  # Variables names as array from statement
  def variables_arr
    @statement
      .scan(/\{(\w+)\}/)
      .flatten
      .uniq
  end

  private

  def run_in_trasaction
    ActiveRecord::Base.transaction do
      yield
      raise ActiveRecord::Rollback
    end
  end

  # Transform SQL statement from :key1, key2, ... to $1, $2, ...
  def transformed_statement
    hash_with_brackets = @variables_hash.transform_keys do |key|
      "{#{key}}"
    end
    # Replace {name1}, {nameN} to $1, $N
    @statement.gsub(
      /\{(\w+)\}/,
      hash_with_brackets
    )
  end

  # Variables names as hash from statement maped to $1, $N variables names
  def variables_hash
    result = {}
      @variables_arr.each_with_index do |var, index|
        result[var] = "$#{index + 1}"
      end
    result
  end

  # Transform hash {variable_name => value} to [$1, $N] array
  # (result is array values for replace $1, $N variables names)
  def bindings
   @variables_from_custom_report_result.sort_by do |k, v|
     @variables_hash[k]
    end.map { |key, value| [nil, value] }
  end
end
