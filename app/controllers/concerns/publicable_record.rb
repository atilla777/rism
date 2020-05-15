# frozen_string_literal: true

module PublicableRecord
  extend ActiveSupport::Concern

  def publicate
    @record = record
    authorize @record
    authorize Publication
    set_published
    @model = model
    render 'publicate'
  end

  private

  def set_published
    publication = Publication.find_or_initialize_by(
      publicable_id: record.id,
      publicable_type: model.to_s
    )
    unless publication.persisted?
      publication.save
      notify_self_subscriptors
      notify_delivery_list_members
    end
  end

  def notify_self_subscriptors
    PublicationMailer.with(
      publicable_type: model.to_s,
      publicable_id: @record.id,
      user: current_user
    ).notify.deliver_later
  end

  def notify_delivery_list_members
    DeliverySubjectMailer.with(
      deliverable_type: model.to_s,
      deliverable_id: @record.id,
      current_user: current_user
    ).notify.deliver_later
  end
end
