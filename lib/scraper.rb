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
    websites = website.css(".social-icon-container").children.css("a").map { |elm| elm.attribute('href').value}
    websites.each do |link|
      if websites.include?("linkedin")
        student[:linkedin] = link
      elsif websites.include?("github")
        student[:github] = link
      elsif websites.include?("twitter")
        student[:twitter] = link
      else
        student[:blog] = link
      end
    end

    student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    student
  end

end
