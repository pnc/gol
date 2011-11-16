require 'matrix'

class Matrix

  def set(row_index, column_index, value)
    @rows[row_index][column_index] = value
  end

  def index_valid?(row_index, column_index)
    row_index >= 0 && row_index < @rows.size && (
      (row = @rows[row_index]) && column_index >= 0 && column_index < row.size
    )
  end

  def neighbors(row, column)
    neighbors = []

    [
      [-1, 0],
      [-1, 1],
      [0, 1],
      [1, 1],
      [1, 0],
      [1, -1],
      [1, 0],
      [-1, -1]
    ].each do |(row, column)|
      neighbors << element(row, column) if index_valid?(row, column)
    end

    return neighbors
  end

end

class Runner
  # Represent living cells with 'X', dead ones with a .
  
  #              v - THIS IS AN ARRAY OF ROWS
  def initialize(initial_board)
    @board = Matrix.rows(initial_board)
  end

  def next_step!
    new_board = Matrix.rows(@board.to_a)

    @board.each_with_index do |value, row, column|
      new_board.set(row, column, new_value_for(
        @board.neighbors(row, column).find_all { |it| it == 'X' }.size
      ))
    end

    @board = new_board

    return self
  end

  def new_value_for(live_neighbor_count)
    case live_neighbor_count
    when 1
      '.'
    else
      '.'
    end
  end

  def board
    @board.to_a
  end

end

require 'riot'
require 'riot/rr'

context "Runner" do
  context "no life yields no life" do
    setup do
      Runner.new([%w{. . .},
                  %w{. . .},
                  %w{. . .}]).next_step!
    end

    asserts(:board).equals [%w{. . .},
                            %w{. . .},
                            %w{. . .}]
  end
  
  context "a single dude dies" do
    setup do
      Runner.new([%w{. . .},
                  %w{. X .},
                  %w{. . .}]).next_step!
    end

    asserts(:board).equals [%w{. . .},
                            %w{. . .},
                            %w{. . .}]
  end
end

__END__
If you need to use mocks or stubs, checkout out RR:
https://github.com/btakita/rr
