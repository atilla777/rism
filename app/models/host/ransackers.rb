# frozen_string_literal: true

module Host::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :ip do
      Arel.sql("hosts.ip::text")
    end
  end
end
