# frozen_string_literal: true

class ScanResultDecorator < SimpleDelegator
  def show_state
    human_enum_name(:states, state)
  end

  def show_legality
    human_enum_name(:legalities, legality)
  end
end
