class Houston_symphony_concert_CLI::Composer
  attr_accessor :name
  
  @@all = []
  
  def initialize(name)
    @name = name 
    @pieces = []
    @concerts = []
    save
  end 
  
  def save 
    @@all << self 
  end 
  
  def self.all 
    @@all 
  end
  
  def concerts
    @concerts 
  end 
  
  def pieces
    @pieces
  end 
  
  def delete_pieces
    @pieces.clear
  end 
  
  def add_piece(piece)
    if !@pieces.include?(piece)
      @pieces << piece
    if piece.composer.class != Composer
        piece.composer = self
      end
    end 
  end 
  
  def self.find_by_name(name) 
    self.all.detect {|artist| artist.name === name}
  end
    
  
  def self.find_or_create_by_name(name)
    result = self.find_by_name(name)
    if result != nil
      return result
    else 
      result = self.new(name)
    end
    result
  end
  
end 

