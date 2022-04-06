# frozen_string_literal: true

module Task::Ransackers
  extend ActiveSupport::Concern

  included do
    ransacker :id_str do
      Arel.sql('tasks.id::text')
    end
  end
end
