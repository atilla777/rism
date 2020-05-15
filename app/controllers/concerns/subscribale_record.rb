# frozen_string_literal: true

module SubscribaleRecord
  extend ActiveSupport::Concern

  included do
    before_action :set_subscription, only: [:index]
  end

  # Add user to model changes subscription list
  def toggle_subscription
    authorize model
    authorize Subscription
    subscription_toggle
    @model = model
    render 'toggle_subscription'
  end


  private

  def subscription_toggle
    subscription = Subscription.find_or_initialize_by(
      user_id: current_user.id,
      publicable_type: model.to_s
    )
    if subscription.persisted?
      subscription.destroy
      @subscription = false
    else
      subscription.save
      @subscription = true
    end
  end

  def set_subscription
    @subscription = Subscription.exists?(
      user_id: current_user.id,
      publicable_type: model.to_s
    )
  end
end
