require 'gosu'
include Gosu

class Player < Character
  def initialize(window)
    @image = Image.new(window, "player.png" , false)
    @x = @y = 0
    @speed_x = 5
  end
  

  def move_left
    if @x > 25 and @x < SCREEN_WIDTH then
      @x = @x - @speed_x
    end
  end
  
  def move_right
    if @x > 0 and @x < SCREEN_WIDTH-25 then
      @x = @x + @speed_x
    end
  end
  
  def distance(enemy)
    return Math.sqrt((enemy.x - @x) ** 2 + (enemy.y - @y) ** 2)
  end
  
  def collide(enemy)
    return distance(enemy) < 40
  end
end