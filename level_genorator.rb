#! /usr/local/bin/ruby

require "./main.rb"

width = AlienAttack::BOARDWIDTH
height = AlienAttack::BOARDHEIGHT

grid = ""

height.times do |y|
  if y + 1 == height || y == 0
    new_row = ""
    width.times do
      new_row += "."
    end
    grid += new_row + "\n"
  else
    start_x_1 = rand(width - 10)
    end_x_1 = start_x_1 + 5 + rand(5)
    start_x_2 = rand(width - 10)
    end_x_2 = start_x_2 + 5 + rand(5)
    new_row = ""
    width.times do |x|
      if (x >= start_x_1 && x <= end_x_1) || (x >= start_x_2 && x <= end_x_2) || x == 0 || x + 1 == width
        new_row += "."
      else
        new_row += " "
      end
    end
    grid += new_row + "\n"
  end
end

File.open("data/1.txt", "w") { |f| f.write grid }