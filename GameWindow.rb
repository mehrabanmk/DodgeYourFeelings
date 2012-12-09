require 'gosu'
include Gosu
require 'Character'
require 'Player'
require 'Enemy'

class GameWindow < Window
#  @num_enemies = 5
#  $enemies = Array.new(@num_enemies)
  def initialize
#    @bgimage = Image.new(self, "s1.gif" , false)
    @screen_width = 640
    @screen_height = 480
    super @screen_width, @screen_height, false
    self.caption = "Dodgeball"
    
    @lose = false
    
    File.open('highscore.txt').each_line{ |s|
      @current_hiscore = Integer(s.to_i)
  }
    @hiscore = false
    @score = 0
    @lose_img = Image.new(self, "losescreen.png", false)
    @hiscore_img = Image.new(self, "hiscorescreen.png", false)
    @replay_timer = 0
    
    @player = Player.new(self)
    @player.set_pos(@screen_width / 2, @screen_height - 30)
    
    @i = 0
    @num_enemies = 5
    $enemies = Array.new(@num_enemies)
    until @i == @num_enemies do
#      Thread.new {sleep(Random.rand(100) / 100)}
      $enemies[@i] = Enemy.new(self, Random.rand(@screen_width), Random.rand(-350..-30))
      @i = @i + 1
    end
    
    @font = Font.new(self, default_font_name, 20)
    @hiscore_font = Font.new(self, default_font_name, 50)
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
#        puts "you lose"
        @lose = true
        if @score > @current_hiscore then
          File.open("highscore.txt", 'w') {|f| f.write(@score) }
          @current_hiscore = @score
          @hiscore = true
        end
      end
      e.move
      if e.y > @screen_height + 30 then
            e.set_pos(Random.rand(@screen_width), Random.rand(-350..-30))
      end
    end
    
    if not @lose then
      @score = @score + 1
    end
    
    if @lose then
#      Thread.new {sleep 5000}
#      sleep(5)
      @replay_timer = @replay_timer + 1
      if @replay_timer > 599
        @lose = false
        @score = 0
        @hiscore = false
        @replay_timer = 0
      end
    end
  end
  
  def draw
#    @bgimage.draw(0, 0, 0)
    if not @lose then
      @font.draw("Score: #{@score}", @screen_width * 0.33, 10, 1, 1.0, 1.0, 0xffffffff)
      @font.draw("Hi-Score: #{@current_hiscore}", @screen_width * 0.66, 10, 1, 1.0, 1.0, 0xffffffff)
      @player.draw
      $enemies.each do |e|
        e.draw
      end
    end
    if @lose then
      if @hiscore then
        @hiscore_img.draw(0, 0, 0)
        @hiscore_font.draw("#{@score}", @screen_width / 2 - 30, @screen_height / 2, 1, 1.0, 1.0, 0xffffffff)
      end
      if not @hiscore then
        @lose_img.draw(0, 0, 0)
      end
    end
  end
end

GameWindow.new().show
