# frozen_string_literal: true
class InvestigationDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_name_with_digest
    "#{name} (#{Digest::MD5.hexdigest(id.to_s)[-4..-1]})"
  end

#  def show_threat
#    Investigation.human_enum_name(:threat, threat)
#  end
end
