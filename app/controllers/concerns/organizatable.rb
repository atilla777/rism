module Organizatable
  extend ActiveSupport::Concern

  private
  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
          .merge current_user: current_user
  end
end
