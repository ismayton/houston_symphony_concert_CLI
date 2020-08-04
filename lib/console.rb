class Console
  
  def self.first_four_concerts(concert_url)
    array = Scraper.scrape_concerts_page(concert_url)
    counter = 0
    @ordered = {}
    while counter < 4 do
      concert = Concert.new_from_hash(array[counter])
      counter += 1
      @ordered[counter] = concert
      puts "#{counter}. #{concert.date}"
    end
  end

  def self.display_full_details(input)

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
