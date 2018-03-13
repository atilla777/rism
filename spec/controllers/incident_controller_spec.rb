# frozen-string_literal: true

require 'rails_helper'

RSpec.describe IncidentsController, type: :controller do
  include_examples 'record', :incident

  let(:new_record) do
    post(
      :create,
      params: {
        model => attributes_for(model)
      }
    )
  end

  context 'when not global role member with edit privileges' do
    let(:user) do
      create(
        :user_with_right,
        allowed_action: :edit,
        allowed_models: [model_class.to_s]
      )
    end

    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it_behaves_like 'authorized to read'
    it_behaves_like 'authorized to edit'
  end
end
