class HoustonSymphonyConcertCLI::CLI
  attr_accessor :concert_url, :programs, :all_concerts
  def initialize
    puts "Please wait while the season is loaded."
    @concert_url = "https://houstonsymphony.org/tickets/concerts/"
    scrape_four_concerts(@concert_url)
    
    @programs = []
    
    puts "----------------------"
    puts "Welcome to the Houston Symphony Concert CLI! Please choose an option below."
    puts "----------------------"
    puts "1. View next program details."
    puts "2. View next 4 concert dates."
    puts "3. Search all concerts for composer by name"
    input = gets.to_i
    
    if input == 1 
      puts "Option 1"
      display_full_details(1)
      restart_or_quit
    
    elsif input == 2 
      scrape_four_programs(@all_concerts)
      puts "Choose a concert for full details."
      input = gets.to_i
      display_full_details(input)
    
    elsif input == 3 
      scrape_all_programs(HoustonSymphonyConcertCLI::Concert.all)
      puts "Enter Composer Name"
      input = gets.capitalize.chomp
      puts "The following concerts include a piece by #{input}"
      search_by_composer(input)
    end
    
  end
  
  def restart_or_quit
    puts "1. Return to Main Menu"
    puts "2. Quit"
    input = gets.to_i
    if input == 1 
      HoustonSymphonyConcertCLI::CLI.new
    else
      puts "Goodbye!"
    end
  end 
      
  def scrape_all_concerts(concert_url)
    all_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
    all_concerts.each do |info_hash|
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_hash(info_hash)
      puts concert.date
    end 
  end 
  
  def scrape_four_concerts(concert_url)
    counter = 0
    all_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
     while counter < 4
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_hash(all_concerts[counter])
      puts concert.date
      counter += 1 
    end
  end 
  
  def scrape_all_programs(array)
    array.each do |program_hash|
      concert = HoustonSymphonyConcertCLI::Concert.new_from_hash(program_hash)
      @programs << concert
      puts "Scraped: #{concert.date}"
    end 
  end 
  
  def scrape_four_programs(array)
    counter = 0
    while counter < 4 do
      concert = HoustonSymphonyConcertCLI::Concert.new_from_hash(array[counter])
      counter += 1
      @programs[counter] = concert
      puts "#{counter}. #{concert.date}"
    end
  end

  def display_full_details(input)

    returned = HoustonSymphonyConcertCLI::Concert.all[0]
    binding.pry
    puts "----------------------"
    puts "Date: #{returned.date}"
    puts "----------------------"
    puts "#{returned.description}"
    puts "----------------------"
    puts "Program:"
    
    returned.composers.each do |composer|
      puts "Composer: #{composer.name}"
      returned.pieces.each do |piece|
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
    restart_or_quit
  end
  
  def search_by_composer(name)
    composer = HoustonSymphonyConcertCLI::Composer.find_by_name(name)
    HoustonSymphonyConcertCLI::Concert.all.each do |concert|
      if concert.composers.include?(composer)
        puts concert.date 
      end 
    end 
    restart_or_quit
  end 
  

end 
