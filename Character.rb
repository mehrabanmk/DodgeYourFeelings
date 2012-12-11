require 'gosu'
include Gosu

class Character
  attr_accessor :x , :y  
  def set_pos(x, y)
      @x = x
      @y = y
  end
  def draw
    @image.draw_rot(@x, @y, 1, 0)
  end
  
end