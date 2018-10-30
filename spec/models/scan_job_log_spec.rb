require 'rails_helper'

RSpec.describe ScanJobLog, type: :model do
  it { should validate_numericality_of(:scan_job_id).only_integer }
#  it { should validate_uniqueness_of(:scan_job_id)
#        .scoped_to(:jid) }
  it { should validate_presence_of(:start) }
  it { should validate_presence_of(:jid) }
  it { should validate_presence_of(:queue) }
  it { should belong_to(:scan_job) }
end
