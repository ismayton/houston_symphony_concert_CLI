require 'nokogiri'
require 'open-uri'
require 'pry'

class HoustonSymphonyConcertCLI::Scraper 

  def self.scrape_concerts_page(concert_url)
    array = []
    doc = Nokogiri::HTML(open(concert_url))
    concerts = doc.css('.grid-item_content')
    concerts.each do |concert|
      date = concert.css('.grid-sub').text
      title = concert.css('.entry-title.grid-title').text
      program_url = concert.css('.entry-title.grid-title [href]')[0]['href']
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_info(title, date, program_url)
      array << concert
    end
    array
  end
  
  def self.scrape_four_concerts_page(concert_url)
    array = []
    doc = Nokogiri::HTML(open(concert_url))
    concerts = doc.css('.grid-item_content')
    counter = 0
    while counter < 4 do
      date = concerts[counter].css('.grid-sub').text
      title = concerts[counter].css('.entry-title.grid-title').text
      program_url = concerts[counter].css('.entry-title.grid-title [href]')[0]['href']
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_info(title, date, program_url)
      array << concert
      counter += 1
    end
    array
  end
  
  ### How to get the piece name?
  
  def self.scrape_program_page(concert)
    doc = Nokogiri::HTML(open(concert.program_url))
    if doc.css('.concert-description-wrapper.blocks p')[2] != nil
      concert.description = doc.css('.concert-description-wrapper.blocks p')[2].text
    end
    details = doc.css('.col-md-5 p')
    if details.css('b').text != ''
      details.each do |piece|
        composer_array = piece.css('.tg-bold').text.split(' ').collect {|word| word.capitalize}
        composer_name = composer_array.join(' ')
        title = piece.css('b').text
        if composer_name != ''
          composer = HoustonSymphonyConcertCLI::Composer.find_or_create_by_name(composer_name)
          concert.composers << composer
        end
        if title != ''
          piece = HoustonSymphonyConcertCLI::Piece.new(title, composer)
          composer.add_piece(piece)
          concert.pieces << piece
        end 
      end
      
    else
      composers = doc.css('.col-md-5 .tg-bold')
      composers.each do |piece|
        composer_array = piece.text.split(' ').collect {|word| word.capitalize}
        composer_name = composer_array.join(' ')
        if composer_name != ''
          composer = HoustonSymphonyConcertCLI::Composer.find_or_create_by_name(composer_name)
          concert.composers << composer
        end
      end 
    end
  end
  
end 


