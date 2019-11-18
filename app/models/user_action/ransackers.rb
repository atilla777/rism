# frozen_string_literal: true

module UserAction::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :ip_str do
      Arel.sql("user_actions.ip::text")
    end

    ransacker :event_str do
      Arel.sql("user_actions.event::text")
    end

    ransacker :record_id_str do
      Arel.sql("user_actions.record_id::text")
    end
  end
end
