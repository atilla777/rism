class CustomReportJob::Query
  def initialize(statement, values = [])
    @statement = statement
    @variables_arr = variables_arr
    @values = values
  end

  def run
    if @variables_arr.empty? # Sql query without variables (for example - without {name})
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

  # private

  # Transform SQL statement from :key1, key2, ... to $1, $2, ...
  def transformed_statement
    hash_with_brackets = variables_hash.transform_keys do |key|
      "{#{key}}"
    end
    @statement.gsub(
      /\{(\w+)\}/,
      hash_with_brackets
    )
  end

  # Variables names as array from statement
  def variables_arr
    @statement
      .scan(/\{(\w+)\}/)
      .flatten
      .uniq
  end

  # Variables names as hash from statement maped to $1, $N variables style
  def variables_hash
    result = {}
      @variables_arr.each_with_index do |var, index|
        result[var] = "$#{index + 1}"
      end
    result
  end

  # Array values for replace $1, $N variables names
  def bindings
    @values.each_with_object([]) do |var, memo|
      memo << [nil, var]
    end
  end
end
