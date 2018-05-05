# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tag members management', type: :feature do
  given(:organization) { create :organization }
  given(:agreement) do
    create(:agreement, organization_id: organization.id)
  end
  given(:tag_kind) { create :tag_kind, record_type: 'Agreement' }
  given(:tag) { create :tag, tag_kind_id: tag_kind.id }
  given(:tag_member) do
    create(
      :tag_member,
      record_id: agreement.id,
      record_type: 'Agreement',
      tag_id: tag.id
    )
  end

  shared_examples 'authorized to edit tag members in browser' do
    scenario 'can add tag to record', js: true do
      tag
      link = tag_members_path(
        record_type: 'Agreement',
        record_id: agreement.id,
        tag_id: tag.id
      )
      visit polymorphic_path(agreement)
      find("a[href='#tags']").click
      find("a[href='#toggle_tags']").click
      find("a[href='#{link}']").click
      wait_for_ajax

      created_tag_member = TagMember.where(
        record_type: 'Agreement',
        record_id: agreement.id,
        tag_id: tag.id
      ).first
      expect(page).to(
        have_link(
          nil,
          href: tag_member_path(created_tag_member)
        )
      )
    end

    scenario 'can delete tag from record', js: true do
      tag_member
      visit polymorphic_path(agreement)
      link_to_remove = tag_member_path(tag_member)
      link = tag_member_path(tag_member)
      find("a[href='#tags']").click
      find("a[href='#{link}']").click
      confirm
      wait_for_ajax

      expect(page).not_to have_link(
        TagDecorator.new(tag).show_full_name,
        href: link_to_remove
      )
    end
  end

  shared_examples 'not authorized to edit tag members in browser' do
    scenario 'can`t add tag to record', js: true do
      tag
      visit polymorphic_path(agreement)
      find("a[href='#tags']").click
      find("a[href='#toggle_tags']").click
      link = tag_members_path(
        record_type: 'Agreement',
        record_id: agreement.id,
        tag_id: tag.id
      )
      find("a[href='#{link}']").click
      wait_for_ajax

      expect(page).not_to(
        have_link(
          TagDecorator.new(tag).show_full_name,
          href: tag_path(tag)
        )
      )
    end

    scenario 'can`t delete tag from record', js: true do
      tag_member
      link_to_remove = tag_member_path(tag_member)
      visit polymorphic_path(agreement)
      find("a[href='#tags']").click
      find("a[href='#{link_to_remove}']").click
      confirm
      wait_for_ajax

      expect(page).to have_link(
        nil,
        href: link_to_remove
      )
    end
  end

  describe 'role members' do
    let(:tag_members_role) { create(:role, :custom_role) }
    let(:allow_user_edit_tag_members) do
      create(
        :role_member,
        user_id: user.id,
        role_id: tag_members_role.id
      )
      create(
        :right,
        :edit,
        role_id: tag_members_role.id,
        subject_type: 'TagMember'
      )
    end

    background { login(user) }

    after { logout }

    context 'when reader' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :read,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', 'Agreement']
        )
      end

      it_behaves_like 'not authorized to edit tag members in browser'
    end

    context 'when editor' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :edit,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', 'Agreement']
        )
      end

      before { allow_user_edit_tag_members }

      it_behaves_like 'authorized to edit tag members in browser'
    end
  end
end
