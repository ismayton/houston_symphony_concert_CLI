require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper 

  def self.scrape_concerts_page(concert_url)
    array = []
    doc = Nokogiri::HTML(open(concert_url))
    concerts = doc.css('.grid-item_content')
    
    concerts.each do |concert|
      info_hash = {
        :date => concert.css('.grid-sub').text,
        :title => concert.css('.entry-title.grid-title').text,
        :program_url => concert.css('.entry-title.grid-title [href]')[0]['href']
      }
      array << info_hash
    end 
    array
  end 
  
  def self.scrape_description(program_url)
    doc = Nokogiri::HTML(open(program_url))
    description = doc.css('.concert-description-wrapper.blocks p')[2].text
  end 
  
  def self.scrape_program_page(program_url)
    concert_details = []
    doc = Nokogiri::HTML(open(program_url))
    details = doc.css('.col-md-5 p')

    details.each do |piece|
      composer_array = piece.css('.tg-bold').text.split(' ').collect {|word| word.capitalize}
      composer = composer_array.join(' ')
      title = piece.css('b').text
      detail_hash = {}

      if composer != ''
        detail_hash[:composer] = composer
      end
      if title != ''
        detail_hash[:title] = title
      end 
      
      if detail_hash != {}
        concert_details << detail_hash
      end 
    end
    concert_details
  end
  
end 

#program_url = "https://houstonsymphony.org/tickets/concerts/live-from-jones-hall-august-15/"
#concert_details = Scraper.scrape_program_page(program_url)
#binding.pry
