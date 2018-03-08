# frozen_string_literal: true
module Capybara
  module Confirm
    def confirm
      if Gem.loaded_specs.has_key?('data-confirm-modal')
        within('.modal') { click_button I18n.t('views.action.certify') }
      else
        page.accept_confirm
      end
    end
  end
end

RSpec.configure do |config|
  config.include Capybara::Confirm, type: :feature
end
