module DefaultMethods
  extend ActiveSupport::Concern

  included do
    before_action :set_edit_previous_page, only: [:new, :edit]
    before_action :set_show_previous_page, only: [:index]
  end

  private
  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
          #.merge current_user: current_user
  end
end
