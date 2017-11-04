module Organizatable
  extend ActiveSupport::Concern

  included do
    autocomplete :organization, :name, full: true
  end


  private
  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(@record).permitted_attributes)
          .merge current_user: current_user
  end
end
