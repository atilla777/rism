# frozen_string_literal: true

class SearchFilterPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :name,
      :filtred_model,
      :organization_id,
      :user_id,
      :shared,
      :rank,
      :content,
      :description
    ]
  end
end
