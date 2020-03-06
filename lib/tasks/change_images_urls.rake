# frozen_string_literal: true

# Change images urls
#
# To use run:
# rake rism:change_images_urls

namespace :rism do
  desc 'Change images urls.'
  task change_images_urls: [:environment] do |_task, args|
    require 'nokogiri'
    require 'open-uri'
    content = Article.all.each do |article|
      old_base_url =  [
        'uploads',
        'ckeditor',
        'article',
        article.id.to_s
      ].join('/')
      new_base_url = [
      'articles',
      article.id.to_s,
      'images',
      @new_filename
    ].join('/')
      doc = Nokogiri::HTML(article.content)
      doc.css('img').map do |links|
        links['src'] = links['src'].sub!(
         old_base_url,
         new_base_url
        )
      end
      doc.write_to(article.content)
    end
  end
end

def recalculate_for_year(year)
  vulnerabilities = Vulnerability.where("codename LIKE 'CVE-#{year}%'")
  vulnerabilities.each do |vulnerability|
    set_actuality(vulnerability)
  end
end

def set_actuality(vulnerability)
  actuality = Custom::VulnerabilityCustomization.cast_actuality(vulnerability)
  vulnerability.actuality = actuality
  vulnerability.custom_actuality = actuality
  begin
    vulnerability.save!
  rescue => e
    pp "Import error #{line} - #{e}"
  end
end
