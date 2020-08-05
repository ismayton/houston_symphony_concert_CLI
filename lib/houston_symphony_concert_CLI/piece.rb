class Houston_symphony_concert_CLI::Piece
  attr_accessor :title, :composer
  
  @@all = []
  
  def initialize(title, composer = nil)
    @title = title
    if composer.class == Composer
      @composer = composer
      composer.add_piece(self)
    end
    save
  end
  
  def composer=(composer)
    if composer.class == Composer 
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
end 
