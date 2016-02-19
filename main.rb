#! /usr/local/bin/ruby

require "gosu"

module AlienAttack

WIDTH = 800
HEIGHT = 600
BLOCKSIZE = 40
BOARDWIDTH = 50
BOARDHEIGHT = 20

private

class Shop

end

class Board

  attr_reader :player

  def initialize(level_name)
    txt = File.read("data/" + level_name + ".txt")
    lines = txt.split "\n"
    @grid = []
    wall_img = Gosu::Image.new "images/wall.png"
    lines.each_with_index do |line, y|
      new_row = []
      line.split("").each_with_index do |item, x|
        if item == "."
          new_row.push Wall.new x, y, wall_img
        elsif item == " "
          new_row.push nil
        end
      end
      (BOARDWIDTH - new_row.length).times do
        new_row.push nil
      end
      @grid.push new_row
    end
    @player = Player.new
    @target = Gosu::Image.new "images/target.png" 
  end

  def draw(mouse_x, mouse_y)
    @grid.each do |row|
      row.each do |item|
        if !item.nil?
          item.draw
        end
      end
    end
    @player.draw(mouse_x, mouse_y)
  end

  def update
    @player.update @grid
  end

  def key_w
    @player.jump @grid
  end

  def key_a
    @player.left @grid
  end

  def key_s
    @player.down @grid
  end

  def key_d
    @player.right @grid
  end

end

class Player

  attr_reader :x, :y

  def initialize
    @x  = 1.0
    @y  = 1.0
    @yv = 0.0
    @body_image = Gosu::Image.new "images/player_body.png"
    #@gun_image  = Gosu::Image.new "images/lazer_gun.png"
  end

  def draw(mouse_x, mouse_y)
    @body_image.draw(@x * BLOCKSIZE.to_f, @y * BLOCKSIZE.to_f, 0)
    #@gun_imge.draw # pointing at mouse
  end

  def update(grid)
    @y += @yv
    @yv += 0.01
    if @yv >= 0 # down
      if !grid[@y.to_i + 1][@x.to_i].nil? || !grid[@y.to_i + 1][(@x + 0.5).to_i].nil?
        while !grid[@y.to_i + 1][@x.to_i].nil? || !grid[@y.to_i + 1][(@x + 0.5).to_i].nil?
          @y -= 0.1
        end
        @y += 0.1
        @yv = 0
      end
    elsif @yv < 0 # up
      if !grid[@y.to_i][@x.to_i].nil? || !grid[@y.to_i][(@x + 0.5).to_i].nil?
        @yv = 0
      end
    end
  end

  def jump(grid)
    @yv = -0.21 if (!grid[@y.to_i + 1][@x.to_i].nil?) || (!grid[@y.to_i + 1][(@x + 0.5).to_i].nil?)
  end

  def left(grid)
    if grid[@y.to_i][@x.to_i].nil?
      @x -= 0.1
    end
    if !grid[@y.to_i][@x.to_i].nil?
      @x += 0.1
    end
  end

  def down(grid)
    
  end

  def right(grid)
    if grid[@y.to_i][(@x + 0.5).to_i].nil?
      @x += 0.1
    end
    if !grid[@y.to_i][(@x + 0.5).to_i].nil?
      @x -= 0.1
    end
  end

end

class Wall

  def initialize(x, y, img)
    @x = x
    @y = y
    @img = img
  end

  def draw
    @img.draw @x * BLOCKSIZE, @y * BLOCKSIZE, 0
  end

end

public

class Screen < Gosu::Window

  def initialize
    super WIDTH, HEIGHT
    @board = Board.new "1"
    @shop = Shop.new
    @statice = :in_game
  end

  def draw
    if @statice == :in_game
    Gosu.draw_rect 0, 0, WIDTH, HEIGHT, 0xff_66ffff
      Gosu.translate(-@board.player.x * BLOCKSIZE + WIDTH / 2, -@board.player.y * BLOCKSIZE + HEIGHT / 2) do
        @board.draw(mouse_x, mouse_y)
      end
    else
      @shop.draw
    end
  end

  def update
    if @statice == :in_game
      @board.update
      if Gosu::button_down?(Gosu::KbW)
        @board.key_w
      end
      if Gosu::button_down?(Gosu::KbA)
        @board.key_a
      end
      if Gosu::button_down?(Gosu::KbD)
        @board.key_d
      end
    end
  end

  def needs_cursor?
    @statice != :in_game
  end

end
end

AlienAttack::Screen.new.show if __FILE__ == $0