require 'gosu'
include Gosu

class Character
  
  def set_pos(x, y)
      @x = x
      @y = y
  end
  
  def draw
    @image.draw_rot(@x, @y, 1, 0)
  end
  
  def x
    return @x
  end
  
  def y
    return @y
  end
end