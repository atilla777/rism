require 'rails_helper'

RSpec.describe ScanJobsHost, type: :model do
  it { should validate_numericality_of(:host_id).only_integer }
  it { should validate_numericality_of(:scan_job_id).only_integer }
  it { should belong_to(:host) }
  it { should belong_to(:scan_job) }
end
