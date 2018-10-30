class ApplicationJob < ActiveJob::Base
  attr_accessor :jid

  before_perform do |job|
    job.jid = job.provider_job_id
  end
end
