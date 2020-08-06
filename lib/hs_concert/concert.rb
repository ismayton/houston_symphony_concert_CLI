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
    #concert.description = HoustonSymphonyConcertCLI::Scraper.scrape_description(concert.program_url)
    HoustonSymphonyConcertCLI::Scraper.scrape_program_page(concert)
    #concert_details.each do |music|
     # composer = HoustonSymphonyConcertCLI::Composer.find_or_create_by_name(music[:composer])
    #  piece = HoustonSymphonyConcertCLI::Piece.new(music[:title], composer)
     # concert.composers << composer 
    #  concert.pieces << piece
    #end 
  end 
  
  def details 
    puts "----------------------"
    puts "Date: #{self.date}"
    puts "----------------------"
    puts "#{self.description}"
    puts "----------------------"
    puts "Program:"
    
    self.composers.each do |composer|
      puts "Composer: #{composer.name}"
      self.pieces.each do |piece|
        if piece.composer == composer 
          if piece.title != nil
            puts "  #{piece.title}"
            puts ""
          else
            puts "  TBD"
            puts ""
          end 
        end
      end
    end
  end

end 
