FactoryBot.define do
  factory :scan_result do
    organization
    scan_job
    job_start Time.now
    start Time.now
    finished Time.now
    ip '10.1.1.1'
    port 80
    protocol 'tcp'
    state 0
    legality 0
    service 'http'
    product 'nginx'
    product_version '1.0.1'
    product_extrainfo 'no'
  end
end
