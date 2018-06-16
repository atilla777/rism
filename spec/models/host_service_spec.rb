require 'rails_helper'

RSpec.describe HostService, type: :model do
  it { should validate_numericality_of(:organization_id).only_integer }
  it { should validate_numericality_of(:host_id).only_integer }
  it { should validate_length_of(:name).is_at_least(3).is_at_most(200) }
  it do should validate_uniqueness_of(:port)
        .scoped_to(:host_id)
        .scoped_to(:protocol)
  end
  it do
    should validate_inclusion_of(:port)
    .in_range(0..65535)
  end
  it { should validate_presence_of(:protocol) }

#  it do
#    should define_enum_for(:legality)
#    .with(%i[unknown illegal legal])
#  end
end
