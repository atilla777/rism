require 'rails_helper'

RSpec.describe ScanJobsHost, type: :model do
  it { should validate_numericality_of(:host_id).only_integer }
  it { should validate_numericality_of(:scan_job_id).only_integer }
  it { should validate_uniqueness_of(:scan_job_id)
       .scoped_to(:host_id) }
  it { should belong_to(:host) }
  it { should belong_to(:scan_job) }
end
