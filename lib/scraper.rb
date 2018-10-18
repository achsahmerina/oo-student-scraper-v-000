require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    website = Nokogiri::HTML(open(index_url))
    website.css("div.roster-cards-container").each do |cards|
      cards.css(".student-card a").each do |student|
        profile = "#{student.attr('href')}"
        location = student.css('.student-location').text
        name = student.css('.student-name').text
        students << {name: name, location: location, profile_url: profile}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    website = Nokogiri::HTML(open(profile_url))
    websites = website.css("div.social-icon-container a").collect do |icon|
      icon.attr('href').value
    end
      websites.each do |website|
        if website.include?("linkedin")
          student[:linkedin] = website
        elsif website.include?("github")
          student[:github] = website
        elsif website.include?("twitter")
          student[:twitter] = website
        else student[:blog] = website
        end
        student[:bio]
  end

end
