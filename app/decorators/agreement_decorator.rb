# frozen_string_literal: true

class AgreementDecorator < SimpleDelegator
  def show_prolongation
    if prolongation
      I18n.t('labels.agreement.prolongation')
    else
      I18n.t('labels.agreement.no_prolongation')
    end
  end

  def show_agreement_kind_name
    return '' if agreement_kind.blank?
    agreement_kind.name
  end
end
