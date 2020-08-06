class HoustonSymphonyConcertCLI::Piece
  attr_accessor :title, :composer
  
  @@all = []
  
  def initialize(title, composer = nil)
    @title = title
    if composer.class == HoustonSymphonyConcertCLI::Composer
      @composer = composer
      composer.add_piece(self)
    end
    save
  end
  
  def composer=(composer)
    if composer.class == HoustonSymphonyConcertCLI::Composer 
      @composer = composer
      if !composer.pieces.include?(self)
        composer.pieces << self 
      end
    end
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
  
  def self.find_by_name(name) 
    self.all.detect {|composer| composer.name === name}
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
