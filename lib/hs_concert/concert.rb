require 'pry'

class HoustonSymphonyConcertCLI::Concert
  attr_accessor :title, :date, :description, :program_url
  
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
  
  def self.clear 
    @@all.clear 
  end 
  
  def composers
    @composers
  end 
  
  def pieces 
    @pieces
  end 
  
  def self.concert_from_hash(info_hash)
    title = info_hash[:title]
    date = info_hash[:date]
    concert = HoustonSymphonyConcertCLI::Concert.new(title, date)
    concert.program_url = info_hash[:program_url]
    concert
  end 
  
  def self.concert_from_info(title, date, program_url)
    concert = HoustonSymphonyConcertCLI::Concert.new(title, date)
    concert.program_url = program_url
    concert
  end 
  
  def self.program_from_concert(concert)
    HoustonSymphonyConcertCLI::Scraper.scrape_program_page(concert)
  end

end 

