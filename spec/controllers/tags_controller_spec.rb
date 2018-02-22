# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  include_examples 'record', :tag

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
        .merge(tag_kind_id: create(:tag_kind).id)
      }
    )
  end
end
