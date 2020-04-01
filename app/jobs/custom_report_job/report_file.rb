class CustomReportJob::ReportFile
  def initialize(result, custom_reports_result)
    @result = result
    @custom_reports_result = custom_reports_result
    @store_dir = @custom_reports_result.record_storage_dir
    @file_ext = custom_reports_result.custom_report.result_format
    @new_filename = new_filename
    @file_path = file_path
  end

  def save
    FileUtils.mkdir_p(@store_dir) unless File.directory?(@store_dir)
    return save_error if @result.is_a?(ActiveRecord::ActiveRecordError)
    case @file_ext
    when 'csv'
      save_csv
    when 'json'
      save_json
    end
  end

  private

  def save_csv
    CSV.open(@file_path, "wb", col_sep: ';', encoding: 'Windows-1251') do |csv|
      csv << @result.columns
      @result.rows.each do |row|
        csv << row
      end
    end
    @new_filename
  end

  def save_json
    File.open(@file_path, "wb") do |file|
      file.write({data: @result.to_hash, status: 200}.to_json)
    end
    @new_filename
  end

  def save_error
    File.open(@file_path, "wb") do |file|
      case @file_ext
      when 'csv'
        file.write("!!!Error!!!: #{@result}")
      when 'json'
        file.write({errors: [@result], status: 200}.to_json)
      end
    end
    @new_filename
  end

  def new_filename
    "#{SecureRandom.uuid}.#{@file_ext}"
  end

  def file_path
    "#{@store_dir}/#{@new_filename}"
  end
end
