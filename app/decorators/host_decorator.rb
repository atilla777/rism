# frozen_string_literal: true
class HostDecorator < SimpleDelegator
  def original
    self.__getobj__
  end

  def class
    self.__getobj__.class
  end

  def show_ip
    return '' unless ip.present?
    ip.to_cidr_s
  end
end
