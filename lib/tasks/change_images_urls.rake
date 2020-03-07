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
      puts 22222
      puts article.content
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
    ].join('/')

      doc = Nokogiri::HTML(article.content)

      doc.css('img').map do |links|
        puts 111111111
        puts links['src']
        links['src'].sub!(
         old_base_url,
         new_base_url
        )
        puts links['src']
      end

      article.content = doc.to_html
      article.skip_current_user_check = true
      article.save!
    end
  end
end
