# frozen_string_literal: true

# Export data file format:
# codename (CVE);
# custom_description;
# processed_by_id (User id);
# updated_by_id (User id);
# custom_actuality;
# custom_relevance;
# vulnerability_kind_id;
#
# To use run:
# rake rism:export_vulnerabilities_custom_data['file.txt']

namespace :rism do
  desc 'Export custom data from processed vulnerabilities.'
  task :export_vulnerabilities_custom_data, [:file] => [:environment] do |_task, args|

    fields = %i[codename
              custom_description
              custom_actuality
              custom_relevance
              vulnerability_kind_id]

    vulnerabilities = Vulnerability.where(processed: true)

    CSV.open(args[:file], 'w', {col_sep: ';'}) do |csv|
      vulnerabilities.each do |v|
        csv << [v[:codename],
                v[:custom_description],
                v[:custom_actuality],
                v[:custom_relevance],
                v[:vulnerability_kind_id]]
      end
    end
  end
end
