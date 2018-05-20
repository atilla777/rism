require 'rails_helper'

RSpec.describe ScanResult, type: :model do
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:scan_job_id).only_integer }
  it { should validate_presence_of(:start) }
  it { should validate_presence_of(:finished) }
  it { should validate_presence_of(:ip) }
  it { should validate_presence_of(:port) }
  it { should validate_presence_of(:protocol) }
  it do
    should validate_inclusion_of(:legality)
    .in_array(%w[unknown illegal legal])
  end
  it do
    should validate_inclusion_of(:state)
    .in_array(ScanResult.states.keys)
  end
#  it do
#    should define_enum_for(:legality)
#    .with_values(:unknown, :illegal, :legal)
#  end
end
