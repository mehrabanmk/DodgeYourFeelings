require 'gosu'
include Gosu
require 'Character'
require 'Player'
require 'Enemy'
    SCREEN_WIDTH = 640
    SCREEN_HEIGHT = 480
class GameWindow < Window
  NUM_ENEMIES = 5
  def initialize  
    
    super SCREEN_WIDTH, SCREEN_HEIGHT, false
    @music = Song.new(self, "AlexC.ogg")
    @music.play
    @bgimage = Image.new(self, "bg.png", false)
    self.caption = "Dodge Your Feelings"
    
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
    @player.set_pos(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 30)
    set

    @font = Font.new(self, default_font_name, 20)
    @hiscore_font = Font.new(self, default_font_name, 50)
  end
  def updateMusic
    #if @currentLevel.done then
    @music.stop # Doesn't seem to be necessary
    @music2 = Gosu::Song.new(self, "sfx/track2.mp3")
    @music2.play
    #@music = nil
  end
  
  def set
    i=0
        $enemies = Array.new(NUM_ENEMIES)
        until i == NUM_ENEMIES do
          $enemies[i] = Enemy.new(self, Random.rand(SCREEN_WIDTH), Random.rand(-350..-30))
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
      
      if e.y > SCREEN_HEIGHT + 30 then
            e.set_pos(Random.rand(SCREEN_WIDTH), Random.rand(-350..-30))
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

    if not @lose then
      @bgimage.draw(0, 0, 0)
      @font.draw("Score: #{@score}", SCREEN_WIDTH * 0.33, 10, 1, 1.0, 1.0, 0xffffffff)
      @font.draw("Hi-Score: #{@current_hiscore}", SCREEN_WIDTH * 0.66, 10, 1, 1.0, 1.0, 0xffffffff)
      @player.draw
      $enemies.each do |e|
        e.draw
      end
    end
    if @lose then
      if @hiscore then
        @hiscore_img.draw(0, 0, 0)
        @hiscore_font.draw("#{@score}", SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT / 2, 1, 1.0, 1.0, 0xffffffff)
      end
      if not @hiscore then
        @lose_img.draw(0, 0, 0)
      end
    end
  end
end

GameWindow.new().show
