# frozen_string_literal: true

# Import data file format:
# codename (CVE);
# custom_description;
# processed_by_id (User id);
# updated_by_id (User id);
# custom_actuality;
# custom_relevance;
# vulnerability_kind_id;
#
# Run:
# rake rism:import_vulnerabilities_custom_data['file.txt, Administrator']

namespace :rism do
  desc 'Import custom data from processed vulnerabilities.'
  task :import_vulnerabilities_custom_data, [:file, :user_name] => [:environment] do |_task, args|

    fields = %i[codename
              custom_description
              custom_actuality
              custom_relevance
              vulnerability_kind_id]

    current_user = User.find_by_name(args[:user_name])

    CSV.foreach(args[:file], {col_sep: ';'}) do |line|
      attributes = Hash[ fields.zip(line) ]
      begin
        vulnerability = Vulnerability.find_by_codename(attributes[:codename])
        vulnerability.update_attributes!(
          attributes.merge(
            processed: true,
            processed_by_id: current_user.id,
            current_user: current_user
          )
        )
      rescue => e
        pp "Import error #{line} - #{e}"
      end
    end
  end
end
