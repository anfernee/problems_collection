
class Puzzle
  E = 0
  R = 1
  B = 2

  LEFT  = [0, -1]
  RIGHT = [0, 1]
  UP    = [-1, 0]
  DOWN  = [1, 0]

  attr_accessor :array, :point

  def initialize
    @array = [
      [E, R, B, B],
      [R, R, B, B],
      [R, R, B, B],
      [R, R, B, B],
    ]
    @point = [0, 0]
  end

  def go_left
    go(LEFT)
  end

  def go_right
    go(RIGHT)
  end

  def go_up
    go(UP)
  end

  def go_down
    go(DOWN)
  end

  def go(direction)
    new_point = [ point[0] + direction[0], point[1] + direction[1] ]

    out = nil
    out = 'up' if new_point[0] < 0
    out = 'down' if new_point[0] > 3
    out = 'left' if new_point[1] < 0
    out = 'right' if new_point[1] > 3

    raise 'out of %s boundary' % out if out

    array[point[0]][point[1]] = array[new_point[0]][new_point[1]]
    array[new_point[0]][new_point[1]] = E
    @point = new_point
  end

  def print_me
    for row in array
      for item in row
        print(item)
        print(' ')
      end
      puts
    end
    puts
  end
end

puzzle = Puzzle.new
puzzle.print_me

path = ''

while true do
  print '> '
  input = STDIN.gets.chomp

  if input.start_with? 'q'
    puts 'path: ' + path
    break
  elsif input.start_with? 'p'
    puts 'path: ' + path
  end


  begin
    input.split('').each do |char|
      if char == 'u' or char == 'U'
        puzzle.go_up
      elsif char == 'd' or char == 'D'
        puzzle.go_down
      elsif char == 'l' or char == 'L'
        puzzle.go_left
      elsif char == 'r' or char == 'R'
        puzzle.go_right
      end
    end
    path += input
  rescue Exception => e
    puts e.message
  end
  puzzle.print_me
end
