# frozen_string_literal: true
class IndicatorDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_ioc_kind
    Indicator.human_enum_name(:ioc_kind, ioc_kind)
  end

  def show_danger
    return I18n.t('labels.indicator.danger') if danger
    I18n.t('labels.indicator.not_danger')
  end

  def show_trust_level
    Indicator.human_enum_name(:trust_level, trust_level)
  end

  def show_investigation_full_name
    id_digest = Digest::MD5.hexdigest(id.to_s)[-4..-1]
    "##{id_digest} #{investigation.created_at.strftime('%d.%m')} #{investigation.name} (#{investigation.feed.name})"
  end

  def show_appearance
    Indicator.where(content: content).count
  end
end
