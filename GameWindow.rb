require 'gosu'
include Gosu
require 'Character'
require 'Player'
require 'Enemy'
    Screen_width = 640
    Screen_height = 480
class GameWindow < Window
#  @num_enemies = 5
#  $enemies = Array.new(@num_enemies)
  def initialize
#    @bgimage = Image.new(self, "s1.gif" , false)
    
    super Screen_width, Screen_height, false
    self.caption = "Dodgeball"
    @num_enemies = 5
    @lose = false
    
    File.open('highscore.txt').each_line{ |s|  @current_hiscore = Integer(s.to_i)}
    @hiscore = false
    @score = 0
    @lose_img = Image.new(self, "losescreen.png", false)
    @hiscore_img = Image.new(self, "hiscorescreen.png", false)
    @replay_timer = 0
    @enemy_speed = 5
    @difficulty_timer = 1
    
    @player = Player.new(self)
    @player.set_pos(Screen_width / 2, Screen_height - 30)
    set

    @font = Font.new(self, default_font_name, 20)
    @hiscore_font = Font.new(self, default_font_name, 50)
  end
  
  def set
    i=0
   
        $enemies = Array.new(@num_enemies)
        until i == @num_enemies do
          $enemies[i] = Enemy.new(self, Random.rand(Screen_width), Random.rand(-350..-30))
          i = i + 1
        end
        
  end
  
  
  def update
    if button_down? KbLeft then
      @player.move_left
    end
    
    if button_down? KbRight then
      @player.move_right
    end
    
    $enemies.each do |e|
      if @player.collide(e) then
         @lose = true
        if @score > @current_hiscore then
          File.open("highscore.txt", 'w') {|f| f.write(@score) }
          @current_hiscore = @score
          @hiscore = true
        end
      end
      
      e.move
      
      if e.y > Screen_height + 30 then
            e.set_pos(Random.rand(Screen_width), Random.rand(-350..-30))
      end
      
      if @difficulty_timer % 300 == 0 then
        @enemy_speed = @enemy_speed + 0.1
        e.set_speed(@enemy_speed)
      end
    end
    
    if not @lose then
      @score = @score + 1
    end
    
    if @lose then
#      Thread.new {sleep 5000}
#      sleep(5)
      
      @replay_timer = @replay_timer + 1
      if @replay_timer > 299
        @lose = false
        @score = 0
        @hiscore = false
        @replay_timer = 0
        @enemy_speed = 5
        @difficulty_timer = 1
      end
      
      set
    end
    
    @difficulty_timer = @difficulty_timer + 1
  end
  
  def draw
#    @bgimage.draw(0, 0, 0)
    if not @lose then
      @font.draw("Score: #{@score}", Screen_width * 0.33, 10, 1, 1.0, 1.0, 0xffffffff)
      @font.draw("Hi-Score: #{@current_hiscore}", Screen_width * 0.66, 10, 1, 1.0, 1.0, 0xffffffff)
      @player.draw
      $enemies.each do |e|
        e.draw
      end
    end
    if @lose then
      if @hiscore then
        @hiscore_img.draw(0, 0, 0)
        @hiscore_font.draw("#{@score}", Screen_width / 2 - 30, Screen_height / 2, 1, 1.0, 1.0, 0xffffffff)
      end
      if not @hiscore then
        @lose_img.draw(0, 0, 0)
      end
    end
  end
end

GameWindow.new().show
