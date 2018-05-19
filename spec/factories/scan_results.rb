FactoryBot.define do
  factory :scan_result do
    organization
    scan_job
    job_time
    ip '10.1.1.1'
    port 80
    protocol 'tcp'
    state 1
    service 'http'
    legality 1
    product 'nginx'
    product_version '1.0.1'
    product_extrainfo 'no'
  end
end
