class  AgreementDecorator < SimpleDelegator
  def beginning_date
    beginning.strftime("%d.%m.%Y")
  end
end
