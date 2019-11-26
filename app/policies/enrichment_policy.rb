# frozen_string_literal: true

class EnrichmentPolicy < ApplicationPolicy
  def permitted_attributes
    %i[
      enrichmentable_type
      enrichmentable_id
      broker
      content
      created_at
    ]
  end
end
