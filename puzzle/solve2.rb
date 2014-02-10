E = 0
R = 1
B = 2

class Puzzle

  LEFT  = -1
  RIGHT = 1
  UP    = -4
  DOWN  = 4

  attr_accessor :num, :now

  def initialize(array=nil)
    i = 0
    if array == nil
      @num = 0
      @now = 0
    else
      for row in array
        for item in row
          i += item
          i = i << 4
        end
      end
      @num = i >> 4
      @now = 0
    end

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
    new = @now + direction
    if direction == UP || direction == DOWN
      if new > 15 or new < 0
        raise 'out of boundary'
      end
    elsif direction == LEFT
      if @now % 4 == 0
        raise 'out of boundary'
      end
    elsif direction == RIGHT
      if new % 4 == 0
        raise 'out of boundary'
      end
    end

    tile = remove(new)
    put(tile, @now)

    @now = new
  end

  def remove(pos)
    mask = 0xf << (15-pos)*4
    x = @num & mask
    @num -= x

    x >> (15-pos)*4
  end

  def get(pos)
    mask = 0xf << (15-pos)*4

    ( @num & mask ) >> (15-pos)*4
  end

  def put(tile, pos)
    @num += tile << (15-pos)*4
  end

  def print_me
    (0..15).each do |i|
      print get(i)
      print ' '

      if (i+1) % 4 == 0
        puts
      end
    end
    puts
  end

  def ==(o)
    o.class == self.class && o.num == @num
  end
  alias_method :eql?, :==

  def dup
    o = Puzzle.new
    o.num = @num
    o.now = @now

    o
  end

end

def dir_to_str(dir)
  if dir == Puzzle::LEFT
    'l'
  elsif dir == Puzzle::RIGHT
    'r'
  elsif dir == Puzzle::UP
    'u'
  elsif dir == Puzzle::DOWN
    'd'
  end
end

init = [
  [E, R, B, B],
  [R, R, B, B],
  [R, R, B, B],
  [R, R, B, B],
]

final = [
  [E, B, R, B],
  [B, R, B, R],
  [R, B, R, B],
  [B, R, B, R],
]

p = Puzzle.new(init)
dest = Puzzle.new(final)

result = {}
queue = [ p ]
paths = [ '' ] # sub-optimal
level = 0

while (p = queue.shift) != nil do
  path = paths.shift

  if path.length > level
    level = path.length
    puts 'searching level %d' % level
  end

  [Puzzle::LEFT, Puzzle::RIGHT, Puzzle::UP, Puzzle::DOWN].each do |dir|
    q = p.dup
    begin
      q.go(dir)
      pp = path + dir_to_str(dir)

      if q == dest
        puts 'done'
        puts 'path: "%s"' % pp
        return
      end

      if result[q.num] != nil
        pass
      else
        result[q.num] = pp

        queue << q
        paths << pp
      end

    rescue
      # do nothing
    end
  end
end

