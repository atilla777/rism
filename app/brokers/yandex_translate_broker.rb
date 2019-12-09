# frozen_string_literal: true

# Translate text on yandex translate service
class YandexTranslateBroker < BaseBroker
  BASE_URI = 'https://translate.yandex.net'.freeze

  API_VERSION = '1.5'.freeze

  LANG = 'en-ru'.freeze

  INDICATORS_KINDS_MAP = {
    text_to_translate: :_text
  }.freeze

  def set_custom_options(text, content_kind='')
     @api_key = ENV['YANDEX_TRANSLATE_KEY']
     @text = text
  end

  private

  def uri
    %W(
      #{BASE_URI}/
      api/
      v#{API_VERSION}/
      tr.json/
      translate?
      lang=#{LANG}
      &key=#{@api_key}
      &text=#{@text}
    ).join
  end

  def error_log_tag
    'YANDEX_TRANSLATE'
  end
end
