class CustomReportJob::ReportFile
  def initialize(result, custom_reports_result)
    @result = result
    @custom_reports_result = custom_reports_result
    @store_dir = store_dir
    @file_ext = 'csv'
    @new_filename = new_filename
    @file_path = file_path
  end

  def save
    FileUtils.mkdir_p(@store_dir) unless File.directory?(@store_dir)
    save_csv
    file_path
#    File.open(@file_path, 'wb') do |file|
#      file.write(@result.read)
#    end
#    file_url
  end

  def save_csv
    CSV.open(@file_path, "wb", col_sep: ';') do |csv|
      csv << @result.columns
      @result.rows.each do |row|
        csv << row
      end
    end
  end

  private

  def store_dir
    Rails.root.join(
      'file_storage',
      'custom_reports',
      @custom_reports_result.id.to_s
    )
  end

  def new_filename
    "#{SecureRandom.uuid}.#{@file_ext}"
  end

  def file_path
    "#{@store_dir}/#{@new_filename}"
  end

#  def file_url
#      [
#        ActionController::Base.relative_url_root,
#        'uploads',
#        'custom_reports',
#        @custom_reports_result.id.to_s,
#        @new_filename
#      ].join('/')
#  end
end
