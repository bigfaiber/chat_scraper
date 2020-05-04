require 'httparty'
require 'nokogiri'
require 'pry'
require 'csv'

CHATURBATE_URL = "https://chaturbate.com/tags/"
 class ChaturbateScraper
  
  def scrape_page url
    Nokogiri::HTML(HTTParty.get(url))
  end

  def tags_with_factor
    raw_tags = scrape_page CHATURBATE_URL
    hash_tag = []
    tags = raw_tags.css(".tag_row").map do |t| 
     {tag: t.children[1]&.text, viewers: t.css(".viewers").text.to_f, rooms: t.css(".rooms").text.to_f, 
              factor: (t.css(".viewers").text.to_f / t.css(".rooms").text.to_f).round(2) }
    end
    tags.sort_by{|h| h[:factor]}
  end
  
 end
 ChaturbateScraper.new.tags_with_factor.each do |t|
   a = []
   t.each_value do |v|
     a << v
   end
   CSV.open("file.csv", "a+") do |csv|
     csv << a
   end
 end
