require 'nokogiri'
require 'open-uri'
require 'byebug'
require "csv"

class Scraper
  def initialize(obj, page)
    @obj = obj
    @page = page
  end

  def row_scraper(from, to, step)
    (from..to).step(step).each do |step|
      if page_step = @page.css('table td')[step]
        @obj << page_step.text.gsub(/ +/, " ")
      end
    end
  end
end

  # Create new csv file
  CSV.open("db.csv", "wb") do |csv|
    csv << ["Licensee Name:", "License Type:", "License Number:", "License Status:", "Expiration Date:", 
      "Issue Date:", "City:", "State:", "Zip:", "County:", "Actions:", "Business Owner-1", "Business Owner-2", 
      "Business Owner-3", "Business Owner-4", "Business Owner-5"]
  end

  # byebug
  # (35999..36010).each do |step|
  (35999..48000).each do |step|
    print "Start scraping page #{step} (#{48000 - step} left): "
    page = Nokogiri::HTML(open("http://www2.dca.ca.gov/pls/wllpub/WLLQRYNA$LCEV2.QueryView?P_LICENSE_NUMBER=#{step}&P_LTE_ID=697"))
    row = []
    if page.text.include? 'Error!'
      row = ["N/A", "N/A", "#{step}", "N/A", "N/A"]
    else
      scraper = Scraper.new(row, page)
      scraper.row_scraper(1, 21, 2)
      scraper.row_scraper(22, 26, 1)
    end
    CSV.open("db.csv", "a+") do |csv|
      csv << row
    end
    puts 'Done'
  end

