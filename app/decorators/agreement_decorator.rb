class AgreementDecorator < SimpleDelegator
  def show_prolongation
    prolongation ? I18n.t('labels.agreement.prolongation') : I18n.t('labels.agreement.no_prolongation')
  end
end
