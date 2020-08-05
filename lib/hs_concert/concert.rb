require 'pry'

class HoustonSymphonyConcertCLI::Concert
  attr_accessor :title, :date, :description
  
  @@all = []
  
  def initialize(title, date)
    @title = title 
    @date = date
    @composers = []
    @pieces = []
    save
  end 
  
  def save 
    @@all << self 
  end 
  
  def self.all 
    @@all 
  end 
  
  def composers
    @composers
  end 
  
  def pieces 
    @pieces
  end 
  
  def self.new_from_hash(info_hash)
    
    title = info_hash[:title]
    date = info_hash[:date]
    concert = HoustonSymphonyConcertCLI::Concert.new(title, date)
    program_url = info_hash[:program_url]
    concert.description = HoustonSymphonyConcertCLI::Scraper.scrape_description(program_url)
    
    concert_details = HoustonSymphonyConcertCLI::Scraper.scrape_program_page(program_url)
    concert_details.each do |music|
      composer = HoustonSymphonyConcertCLI::Composer.find_or_create_by_name(music[:composer])
      piece = HoustonSymphonyConcertCLI::Piece.new(music[:title], composer)
      concert.composers << composer 
      concert.pieces << piece
    end 
    concert
  end 

end 
