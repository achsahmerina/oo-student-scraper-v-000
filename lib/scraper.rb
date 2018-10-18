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
    links = website.css(".social-icon-container").children.css("a").map { |elm| elm.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        student[:linkedin] = link
      elsif link.include?("github")
        student[:github] = link
      elsif link.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:bio] = website.css("div.bio-content.content-holder div.description-holder p").text if website.css("div.bio-content.content-holder div.description-holder p")
    student[:profile_quote] = website.css(".profile-quote").text if website.css(".profile-quote")

    student
  end

end
