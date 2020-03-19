# frozen_string_literal: true

# Change images urls
#
# To use run:
# rake rism:change_images_urls

namespace :rism do
  desc 'Change images urls.'
  task change_images_urls: [:environment] do |_task, args|
    require 'nokogiri'
    #require 'open-uri'
    Article.all.each do |article|
      # Log old content to console
      csv_str = CSV.generate do |csv|
        csv << [article.id, article.content]
      end
      puts csv_str

      old_base_url =  [
        'uploads',
        'ckeditor',
        'article',
        article.id.to_s
      ].join('/')

      new_base_url = [
      'articles',
      article.id.to_s,
      'files',
    ].join('/')

      doc = Nokogiri::HTML(article.content)

      doc.css('img').map do |links|
        links['src'] = links['src'].sub(
         old_base_url,
         new_base_url
        )
      end

      article.content = doc.to_html
      article.skip_current_user_check = true
      article.save!
    end
  end
end
