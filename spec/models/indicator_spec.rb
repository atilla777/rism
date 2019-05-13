require 'rails_helper'

RSpec.describe Indicator, type: :model do
  it { should validate_numericality_of(:investigation_id).only_integer }
  it { should validate_numericality_of(:user_id).only_integer }
  it { should validate_presence_of :content}
  it { should validate_uniqueness_of(:content).scoped_to(:investigation_id)}
  it { should belong_to :investigation}
end
