# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Incident, type: :model do
  it { should validate_presence_of :event_description }
  it do
    should validate_inclusion_of(:damage)
      .in_array(Incident.damages.keys)
  end
  it do
    should validate_inclusion_of(:severity)
      .in_array(Incident.severities.keys)
  end
  it do
    should validate_inclusion_of(:state)
      .in_array(Incident.states.keys)
  end
end
