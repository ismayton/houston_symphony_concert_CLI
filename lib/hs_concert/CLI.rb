class HoustonSymphonyConcertCLI::CLI
  attr_accessor :concert_url
  
  def initialize
    @concert_url = "https://houstonsymphony.org/tickets/concerts/"
    puts "Please choose from the following:"
    puts "1. Load next 4 concerts"
    puts "2. Load entire remaining season"
    puts "3. Quit"
    input = gets.to_i
    puts "Please wait while the season is loaded."
    if input == 1 
      scrape_four_concerts(@concert_url)
      main_menu
    elsif input == 2 
      scrape_all_concerts(@concert_url)
      main_menu
    else 
      puts "Goodbye!"
    end 
  end 
  
  def main_menu
    puts "----------------------"
    puts "Welcome to the Houston Symphony Concert CLI! Please choose an option below."
    puts "----------------------"
    puts "1. View next upcoming program details"
    puts "2. View upcoming concert dates"
    puts "3. Search concerts for composer by name"
    puts "4. Quit"
    input = gets.to_i
    
    if input == 1
      display_full_details(1)
      restart_or_quit
    
    elsif input == 2 
      counter = 0 
      HoustonSymphonyConcertCLI::Concert.all.each do |concert|
        puts "#{counter + 1}: #{concert.date} #{concert.title}"
        counter += 1 
      end
      puts "Choose a concert for full details."
      input = gets.to_i
      display_full_details(input)
      restart_or_quit
      
    elsif input == 3 
      puts "Enter Composer Name"
      input = gets.capitalize.chomp
      puts "The following concerts include a piece by #{input}:"
      search_by_composer(input)
      restart_or_quit
      
    else 
      puts "Goodbye!"
    end
  end
  
  def restart_or_quit
    puts "1. Return to Main Menu"
    puts "2. Quit"
    input = gets.to_i
    if input == 1 
      main_menu
    elsif input == 2
      puts "Goodbye!"
    end
  end 
   
  ###Concert Scraping 

  def scrape_all_concerts(concert_url)
    all_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
    all_concerts.each do |info_hash|
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_hash(info_hash)
      HoustonSymphonyConcertCLI::Concert.program_from_url(concert)
      puts "#{concert.date}: Complete."
    end 
  end 
  
  def scrape_four_concerts(concert_url)
    counter = 0
    all_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
     while counter < 4
      concert = HoustonSymphonyConcertCLI::Concert.concert_from_hash(all_concerts[counter])
      HoustonSymphonyConcertCLI::Concert.program_from_url(concert)
      puts "#{concert.date}: Complete."
      counter += 1 
    end
  end 
  
  ####program scraping
  
  def program(input)
    index = input.to_i - 1
    concert = HoustonSymphonyConcertCLI::Concert.all[index]
    HoustonSymphonyConcertCLI::Concert.program_from_url(concert)
    puts "Scraped: #{concert.date}"
  end 
  

  ###Display 
  
  def display_full_details(input)
    index = input.to_i - 1
    returned = HoustonSymphonyConcertCLI::Concert.all[index]
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
  end
  
  #Search Composer 
  
  def search_by_composer(name)
    composer = HoustonSymphonyConcertCLI::Composer.find_by_name(name)
    array = []
    counter = 1
    HoustonSymphonyConcertCLI::Concert.all.each do |concert|
      if concert.composers.include?(composer)
        puts "#{counter}. #{concert.date}"
        array << concert
        counter += 1
      end 
    end
    if array == []
      puts "No concerts found."
    end 
    puts ""
  end 
  

end 
