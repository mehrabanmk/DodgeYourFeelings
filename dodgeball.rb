require "rubygems"
require "wx"
include Wx 

class Dodgeball < App
  
  @screen_width = 400
  @screen_height = 400
  @player_x = @screen_width / 2
  @player_y = @screen_height / 2
  
  def on_init
    fr = Frame.new(nil, -1, "Dodgeball")
#    @dc = DC.new
#    @dc.draw_circle(1, 1, 3)
    fr.show
#    fr.paint{|dc| dc.draw_circle(50,50,50)}
    @player = Player.new
    puts @player.x
    
  end
end

Dodgeball.new.main_loop