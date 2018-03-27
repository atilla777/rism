# frozen_string_literal: true

RSpec.shared_examples 'record' do |model|
  let(:model) { model }
  let(:model_class) { model.to_s.classify.constantize }
  let(:record) { create model }
  let(:all_records) { model_class.all }
  let(:new_params) {{}}
  let(:new_record) do
    post(
      :create,
      params: { model => attributes_for(model) }
    )
  end
  let(:update_record) do
    put(
      :update,
      params: {
        id: record.id,
        model => attributes_for(model)
      }
    )
  end
  let(:delete_record) do
    delete :destroy, params: { id: record.id }
  end

  context 'when anonymous user' do
    it_behaves_like 'an anonymous'
  end

  describe 'global role member' do
    let(:user) { create :user, :skip_validation, active: true }

    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    context 'when admin' do
      let(:role) { create :role, :admin }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
    end

    context 'when editor' do
      let(:role) { create :role, :editor }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'authorized to edit'
    end

    context 'when reader' do
      let(:role) { create :role, :reader }

      before do
        create(:role_member, role_id: role.id, user_id: user.id)
      end

      it_behaves_like 'authorized to read'
      it_behaves_like 'unauthorized to edit'
    end
  end

  context 'when not global role member with read privileges' do
    let(:user) do
      create(
        :user_with_right,
        allowed_action: :read,
        allowed_models: [model_class.to_s]
      )
    end

    setup :activate_authlogic

    before do
      create_user_session(user)
    end

    it_behaves_like 'authorized to read'
    it_behaves_like 'unauthorized to edit'
  end
end
