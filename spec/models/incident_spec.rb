# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Incident, type: :model do
  it { should validate_length_of(:name).is_at_least(3).is_at_most(100) }
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_presence_of :event_description }
  it { should belong_to :organization }
  it { should belong_to :user}
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

  describe '#set_closed_at' do
    it 'is called after save' do
      incident = build(:incident)

      expect(incident).to receive(:set_closed_at)
      incident.save
    end

    it 'isn`t set closed_at when state isn`t changed to closed' do
      incident = create(:incident)

      expect(incident.closed_at).not_to be
    end

    it 'is set closed_at when state is changed to closed' do
      incident = create(:incident)
      incident.update(state: 2)

      expect(incident.closed_at).to be
    end

    it 'is reset closed_at when state is changed from closed' do
      incident = create(:incident, state: 2)
      incident.update(state: 1)

      expect(incident.closed_at).not_to be
    end
  end
end
