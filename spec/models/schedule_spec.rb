# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  subject { build(:schedule) } # fix shoulda error on polymorphic
  it { should validate_uniqueness_of(:job_id).scoped_to(:job_type) }
  it { should validate_presence_of(:job_id) }
  it { should validate_presence_of(:job_type) }

  it 'can store minutes' do
    schedule = build(:schedule, minutes: [0, 44, 59])
    expect(schedule).to be_valid
  end

  it 'can`t store wrong minutes' do
    schedule = build(:schedule, minutes: [0, 80, 59])
    expect(schedule).not_to be_valid
    expect(schedule.errors.messages[:minutes]).to be
  end

  it 'can store hours' do
    schedule = build(:schedule, hours: [0, 11, 23])
    expect(schedule).to be_valid
  end

  it 'can`t store wrong  hours' do
    schedule = build(:schedule, hours: [0, 44, 23])
    expect(schedule).not_to be_valid
    expect(schedule.errors.messages[:hours]).to be
  end

  it 'can store week_days' do
    schedule = build(:schedule, week_days: [0, 3, 6])
    expect(schedule).to be_valid
  end

  it 'can`t store wrong  week_days' do
    schedule = build(:schedule, week_days: [0, 8, 6])
    expect(schedule).not_to be_valid
    expect(schedule.errors.messages[:week_days]).to be
  end

  it 'can store months' do
    schedule = build(:schedule, months: [1, 6, 12])
    expect(schedule).to be_valid
  end

  it 'can`t store wrong  months' do
    schedule = build(:schedule, months: [1, 13, 12])
    expect(schedule).not_to be_valid
    expect(schedule.errors.messages[:months]).to be
  end

  it 'can store month_days' do
    schedule = build(:schedule, month_days: [1, 15, 31])
    expect(schedule).to be_valid
  end

  it 'can`t store wrong  months' do
    schedule = build(:schedule, months: [1, 34, 31])
    expect(schedule).not_to be_valid
    expect(schedule.errors.messages[:month_days]).to be
  end

  it { should belong_to(:job) }
  #it { should have_one(:organization) }
end
