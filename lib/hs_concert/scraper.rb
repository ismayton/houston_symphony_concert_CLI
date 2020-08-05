require 'nokogiri'
require 'open-uri'
require 'pry'

class HoustonSymphonyConcertCLI::Scraper 

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
    if doc.css('.concert-description-wrapper.blocks p')[2] != nil
      description = doc.css('.concert-description-wrapper.blocks p')[2].text
    end 
  end 
  
  ### Weird formatting for some pages, need a flow control and secondary scrape setup for tg-bold composer name and following text
  
  ### Find a way to scrape piece name 
  ### find flow control for scrape between format types
  
  ### details = doc.css('.col-md-5') - remove the p
  ### details.css('p .tg-bold')[0].text = Handel/L. Shaw
  ### How to get the piece name?
  
  def self.scrape_program_page(program_url)
    concert_details = []
    doc = Nokogiri::HTML(open(program_url))
    details = doc.css('.col-md-5 p')
    
    details.each do |piece|
      composer_array = piece.css('.tg-bold').text.split(' ').collect {|word| word.capitalize}
      composer = composer_array.join(' ')
      title = piece.css('b').text
      binding.pry
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


