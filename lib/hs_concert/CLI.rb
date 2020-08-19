class HoustonSymphonyConcertCLI::CLI
  attr_accessor :concert_url
  
  def initialize
    @concert_url = "https://houstonsymphony.org/tickets/concerts/"
    puts "Please choose from the following:"
    puts "1. Load next 4 concerts"
    puts "2. Load entire remaining season"
    puts "3. Quit"
    input = gets.to_i
    if input == 1 
      puts "Please wait while the next 4 concerts are loaded."
      scrape_four_concerts(@concert_url)
      main_menu
    elsif input == 2 
      puts "Please wait while the season is loaded."
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
   
   
  #Concert Scraping 

  def scrape_all_concerts(concert_url)
    all_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
    all_concerts.each do |concert|
      HoustonSymphonyConcertCLI::Concert.program_from_concert(concert)
      puts "#{concert.date}: Complete."
    end 
  end 
  
  def scrape_four_concerts(concert_url)
    counter = 0
    four_concerts = HoustonSymphonyConcertCLI::Scraper.scrape_four_concerts_page(concert_url)
    while counter < 4
      HoustonSymphonyConcertCLI::Concert.program_from_concert(four_concerts[counter])
      puts "#{four_concerts[counter].date}: Complete."
      counter += 1 
    end
  end 


  #Display 
  
  def display_full_details(input)
    index = input.to_i - 1
    concert = HoustonSymphonyConcertCLI::Concert.all[index]
    details(concert)
  end
  
  def details(concert) 
    puts "----------------------"
    puts "Date: #{concert.date}"
    puts "----------------------"
    puts "#{concert.description}"
    puts "----------------------"
    puts "Program:"
    
    concert.composers.each do |composer|
      puts "Composer: #{composer.name}"
      concert.pieces.each do |piece|
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
    array = HoustonSymphonyConcertCLI::Concert.all.select {|concert| concert.composers.include?(composer)}
    
    if array.size == 0
      puts "No concerts found."
      return 
    else 
      counter = 1
      puts "Choose a concert for full details."
      array.each do |concert|
        puts "#{counter}. #{concert.date}"
        counter += 1
      end 
      puts "#{counter}. Return to Main Menu"
      puts "#{counter + 1}. Quit"
      input = gets.to_i
      index = input - 1
      if index < array.size  
        array[index].details
      elsif input == counter 
        main_menu
      elsif input == counter + 1
        puts "Goodbye!"
        return
      end
    end 
  end 
  
end 
