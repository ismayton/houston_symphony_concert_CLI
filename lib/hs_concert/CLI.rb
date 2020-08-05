class HoustonSymphonyConcertCLI::CLI
  attr_accessor :concert_url, :ordered
  def initialize
    @concert_url = "https://houstonsymphony.org/tickets/concerts/"
    puts "Welcome to the Houston Symphony Concert CLI! Please choose an option below."
    puts "1. View next program details."
    puts "2. View next 4 concert dates."
    puts "3. Search all concerts for composer by name"
    
    input = gets.to_i
    
    if input == 1 
      puts "Option 1"
      restart_or_quit
    elsif input == 2 
      first_four_concerts(@concert_url)
      puts "Choose a concert for full details."
      input = gets.to_i
      display_full_details(input)
      restart_or_quit
    elsif input == 3 
      puts "Option 3"
      restart_or_quit
    end
    
  end
  
  def restart_or_quit
    puts "1. Return to Main Menu"
    puts "2. Quit"
    input = gets.to_i
    if input == 1 
      self.new
    else
      puts "Goodbye!"
    end
  end 
      
      
  def first_four_concerts(concert_url)
    array = HoustonSymphonyConcertCLI::Scraper.scrape_concerts_page(concert_url)
    counter = 0
    @ordered = {}
    while counter < 4 do
      concert = HoustonSymphonyConcertCLI::Concert.new_from_hash(array[counter])
      counter += 1
      @ordered[counter] = concert
      puts "#{counter}. #{concert.date}"
    end
  end

  def display_full_details(input)

    returned = @ordered[input]
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
  

end 
