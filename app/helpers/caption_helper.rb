module CaptionHelper
  def caption(record_or_records_or_text)
    caption = case record_or_records_or_text
              when ActiveRecord::Relation
                record_or_records_or_text.klass.model_name.human(count: 2)
              when ActiveRecord::Base
                record_or_records_or_text.class.model_name.human
              else
                record_or_records_or_text
              end
    render 'helpers/caption', caption: caption
  end
end
