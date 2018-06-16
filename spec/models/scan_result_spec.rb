require 'rails_helper'

RSpec.describe ScanResult, type: :model do
  it { should validate_numericality_of(:scan_job_id).only_integer }
  it { should validate_presence_of(:start) }
  it { should validate_presence_of(:finished) }
  it { should validate_presence_of(:ip) }
  it do
    should validate_inclusion_of(:port)
    .in_range(0..65535)
  end
#  it do
#    should define_enum_for(:legality)
#    .with(%i[unknown illegal legal])
#  end
#  it do
#    should validate_inclusion_of(:state)
#    .with(%i[closed closed_filtered filtered unfiltered open_filtered open]%i[unknown illegal legal])
#  end
end
