# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Tag members management', type: :feature do
  given(:resource) { :agreement }
  given(:resource_class) { Agreement }
  given(:organization) { create :organization }
  given(:record) do
    create(resource, organization_id: organization.id)
  end
  given(:tag) { create :tag }
  given(:tag_member) do
    create(
      :tag_member,
      record_id: record.id,
      record_type: resource_class.to_s,
      tag_id: tag.id
    )
  end

  shared_examples 'authorized to edit tag members in browser' do
    scenario 'can add tag to record', js: true do
      tag
      visit polymorphic_path(record)
      find("a[href='#toggle_tags']").click
      link = tag_members_path(
        record_type: record.class.name,
        record_id: record.id,
        tag_id: tag.id
      )
      find("a[href='#{link}']").click
      page.accept_confirm
      wait_for_ajax

      created_tag_member = TagMember.where(
        record_type: record.class.name,
        record_id: record.id,
        tag_id: tag.id
      ).first
      expect(page).to(
        have_link(tag.name, href: tag_member_path(created_tag_member))
      )
    end

    scenario 'can delete tag from record', js: true do
      tag_member
      visit polymorphic_path(record)
      link_to_remove = tag_member_path(tag_member)
      link = tag_member_path(tag_member)
      find("a[href='#{link}']").click
      page.accept_confirm
      wait_for_ajax

      expect(page).not_to have_link(tag.name, href: link_to_remove)
    end
  end

  shared_examples 'not authorized to edit tag members in browser' do
    scenario 'can`t add tag to record', js: true do
      tag
      visit polymorphic_path(record)
      find("a[href='#toggle_tags']").click
      link = tag_members_path(
        record_type: record.class.name,
        record_id: record.id,
        tag_id: tag.id
      )
      find("a[href='#{link}']").click
      page.accept_confirm
      wait_for_ajax

      expect { find("a[data-method='delete']", text: tag.name) }.to raise_error
    end

    scenario 'can`t delete tag from record', js: true do
      tag_member
      visit polymorphic_path(record)
      link_to_remove = tag_member_path(tag_member)
      link = tag_member_path(tag_member)
      find("a[href='#{link}']").click
      page.accept_confirm
      wait_for_ajax

      expect(page).to have_link(tag.name, href: link_to_remove)
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
          allowed_models: ['Organization', resource_class.name]
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
          allowed_models: ['Organization', resource_class.name]
        )
      end

      before { allow_user_edit_tag_members }

      it_behaves_like 'authorized to edit tag members in browser'
    end
  end
end
