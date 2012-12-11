require 'gosu'
include Gosu

class Enemy < Character
  def initialize(window, x, y)
    @image = Image.new(window, "enemy.png", false)
    @x = x
    @y = y
    @speed_y = 5
  end

  def move
    @y = @y + @speed_y
  end
  
  def set_speed(speed)
    @speed_y = speed
  end
  
end