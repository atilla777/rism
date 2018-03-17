require 'rails_helper'

RSpec.describe User, type: :model do

  it { should validate_numericality_of(:rank)
       .only_integer }
  it { should validate_numericality_of(:department_id)
       .only_integer }
  it { should validate_length_of(:department_name)
       .is_at_least(0)
       .is_at_most(100) }
  it { should belong_to(:department) }
  it { should belong_to(:organization) }
  it { should have_many :rights}

  describe '#organization_id' do
    it { should validate_numericality_of(:organization_id)
        .only_integer }

    context 'when creating and belongs to department' do
      it 'set organization_id' do
        organization = build(:organization)
        user = build(:user, organization_id: organization.id)

        expect(user.organization_id).to eq(organization.id)
      end
    end
  end

  describe '#email' do
    context 'when user allowed to login' do
      before(:each) { allow(subject).to receive(:active).and_return(true) }
      it { is_expected.to validate_presence_of(:email) }
    end

    context 'when user not allowed to login' do
      before { allow(subject).to receive(:active).and_return(false) }
      it { is_expected.not_to validate_presence_of(:email) }
    end
  end

  let(:user) { create(:user) }
  let(:admin_role) { create(:role,
                      :admin) }
  let(:editor_role) { create(:role,
                      :editor) }
  let(:reader_role) { create(:role,
                      :reader) }
  let(:user_is_admin) { create(:role_member,
                                    user_id: user.id,
                                    role_id: admin_role.id) }
  let(:user_is_editor) { create(:role_member,
                                    user_id: user.id,
                                    role_id: editor_role.id) }
  let(:user_is_reader) { create(:role_member,
                                    user_id: user.id,
                                    role_id: reader_role.id) }
  let(:parent_organization) { create(:organization) }
  let(:organization) { create(:organization, parent_id: parent_organization.id) }
  let(:child_organization) { create(:organization, parent_id: organization.id) }
  let(:grand_child_organization) { create(:organization, parent_id: child_organization.id) }
  let(:foreign_organization) { create(:organization) }
  let(:custom_role) { create(:role, :custom_role) }
  let(:user_custom_role) { create(:role_member,
                                   user_id: user.id,
                                   role_id: custom_role.id) }

  describe 'when user is like access subject' do
    it { should have_many(:roles) }
    it { should have_many(:role_members) }
    it { should have_many(:rights) }


    context 'when user is main admin with id = 1' do
      it 'can`t be removed' do
        user = create(:user, id: 1)
        user.destroy

        expect(User.find(1)).to be
      end
    end

    context 'when user is a global admin' do
      before :each do
        user
        admin_role
        user_is_admin
      end

      it 'respond to #admin? as true' do
        expect(user.admin?).to be_truthy
      end

      it 'respond to #admin_editor? as true' do
        expect(user.admin_editor?).to be_truthy
      end

      it 'respond to #admin_editor_reader? as true' do
        expect(user.admin_editor_reader?).to be_truthy
      end
    end

    context 'when user is a global editor' do
      before :each do
        user
        editor_role
        user_is_editor
      end

      it 'respond to #admin_editor? as true' do
        expect(user.admin_editor?).to be_truthy
      end
      it 'respond to #admin_editor_reader? as true' do
        expect(user.admin_editor_reader?).to be_truthy
      end
      it 'respond to #admin? as false' do
        expect(user.admin?).to be_falsy
      end
    end

    context 'when user is a global reader' do
      before :each do
        user
        reader_role
        user_is_reader
      end

      it 'respond to #admin_editor_reader? as true' do
        expect(user.admin_editor_reader?).to be_truthy
      end

      it  'respond to #admin_editor? as false' do
        expect(user.admin_editor?).to be_falsy
      end

      it  'respond to #admin? as false' do
        expect(user.admin?).to be_falsy
      end
    end

    before :each do
      user
      parent_organization
      organization
      child_organization
      grand_child_organization
      foreign_organization
      custom_role
      user_custom_role
    end

    context 'when user is the organization manger' do
      before :each do
        create(:right, :manage,
               organization_id: organization.id,
               role_id: custom_role.id,
               subject_type: 'Organization',
               subject_id: nil)
      end

      describe '#allowed_organizations_ids' do
        it 'get only allowed ids' do
          allowed_ids = [organization.id,
                         child_organization.id,
                         grand_child_organization.id]

          expect(user.allowed_organizations_ids).to match_array(allowed_ids)
        end
      end

      it 'can manage each allowed organizations' do
        expect(user.can?(:manage, organization)).to be_truthy
        expect(user.can?(:manage, child_organization)).to be_truthy
        expect(user.can?(:manage, grand_child_organization)).to be_truthy
      end

      it 'can edit each allowed organizations' do
        expect(user.can?(:edit, organization)).to be_truthy
        expect(user.can?(:edit, child_organization)).to be_truthy
        expect(user.can?(:edit, grand_child_organization)).to be_truthy
      end

      it 'can read each allowed organizations' do
        expect(user.can?(:read, organization)).to be_truthy
        expect(user.can?(:read, child_organization)).to be_truthy
        expect(user.can?(:read, grand_child_organization)).to be_truthy
      end

      it 'can`t manage not allowed organization' do
        expect(user.can?(:manage, parent_organization)).to be_falsy
        expect(user.can?(:manage, foreign_organization)).to be_falsy
      end

      it 'can`t edit not allowed organization' do
        expect(user.can?(:edit, parent_organization)).to be_falsy
        expect(user.can?(:edit, foreign_organization)).to be_falsy
      end

      it 'can`t read not allowed organization' do
        expect(user.can?(:read, parent_organization)).to be_falsy
        expect(user.can?(:read, foreign_organization)).to be_falsy
      end
    end

    context 'when user is the organization editor' do
      before :each do
        create(:right, :edit,
               organization_id: organization.id,
               role_id: custom_role.id,
               subject_type: 'Organization',
               subject_id: nil)
      end

      describe '#allowed_organizations_ids' do
        it 'get only allowed ids' do
          allowed_ids = [organization.id,
                         child_organization.id,
                         grand_child_organization.id]

          expect(user.allowed_organizations_ids).to match_array(allowed_ids)
        end
      end

      it 'can`t manage each allowed organizations' do
        expect(user.can?(:manage, organization)).to be_falsy
        expect(user.can?(:manage, child_organization)).to be_falsy
        expect(user.can?(:manage, grand_child_organization)).to be_falsy
      end

      it 'can edit each allowed organizations' do
        expect(user.can?(:edit, organization)).to be_truthy
        expect(user.can?(:edit, child_organization)).to be_truthy
        expect(user.can?(:edit, grand_child_organization)).to be_truthy
      end

      it 'can read each allowed organizations' do
        expect(user.can?(:read, organization)).to be_truthy
        expect(user.can?(:read, child_organization)).to be_truthy
        expect(user.can?(:read, grand_child_organization)).to be_truthy
      end

      it 'can`t manage not allowed organization' do
        expect(user.can?(:manage, parent_organization)).to be_falsy
        expect(user.can?(:manage, foreign_organization)).to be_falsy
      end

      it 'can`t edit not allowed organization' do
        expect(user.can?(:edit, parent_organization)).to be_falsy
        expect(user.can?(:edit, foreign_organization)).to be_falsy
      end

      it 'can`t read not allowed organization' do
        expect(user.can?(:read, parent_organization)).to be_falsy
        expect(user.can?(:read, foreign_organization)).to be_falsy
      end
    end

    context 'when user is the organization reader' do
      before :each do
        create(:right, :read,
               organization_id: organization.id,
               role_id: custom_role.id,
               subject_type: 'Organization',
               subject_id: nil)
      end

      describe '#allowed_organizations_ids' do
        it 'get only allowed ids' do
          allowed_ids = [organization.id,
                         child_organization.id,
                         grand_child_organization.id]

          expect(user.allowed_organizations_ids).to match_array(allowed_ids)
        end
      end

      it 'can`t manage each allowed organizations' do
        expect(user.can?(:manage, organization)).to be_falsy
        expect(user.can?(:manage, child_organization)).to be_falsy
        expect(user.can?(:manage, grand_child_organization)).to be_falsy
      end

      it 'can`t edit each allowed organizations' do
        expect(user.can?(:edit, organization)).to be_falsy
        expect(user.can?(:edit, child_organization)).to be_falsy
        expect(user.can?(:edit, grand_child_organization)).to be_falsy
      end

      it 'can read each allowed organizations' do
        expect(user.can?(:read, organization)).to be_truthy
        expect(user.can?(:read, child_organization)).to be_truthy
        expect(user.can?(:read, grand_child_organization)).to be_truthy
      end

      it 'can`t manage not allowed organization' do
        expect(user.can?(:manage, parent_organization)).to be_falsy
        expect(user.can?(:manage, foreign_organization)).to be_falsy
      end

      it 'can`t edit not allowed organization' do
        expect(user.can?(:edit, parent_organization)).to be_falsy
        expect(user.can?(:edit, foreign_organization)).to be_falsy
      end

      it 'can`t read not allowed organization' do
        expect(user.can?(:read, parent_organization)).to be_falsy
        expect(user.can?(:read, foreign_organization)).to be_falsy
      end
    end
  end

  context 'when user is like an organization member' do
    describe '#top_level_organizations' do
      it 'get only parent organizations list' do
        grand_child_organization_user = create(:user,
                                               organization_id: grand_child_organization.id)
        parents = [parent_organization.id,
                   organization.id,
                   child_organization.id,
                   grand_child_organization.id]

        expect(grand_child_organization_user.top_level_organizations.pluck(:id)).to match_array parents
      end
    end
  end
end
