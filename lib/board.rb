class Board
  attr_reader :values, :available_spaces

  def initialize
    @values = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  end

  def available_spaces
    @values.select{|value| value.class == Fixnum}
  end

  def update_board(value, space)
    @values[space] = value
  end

  def won?(player = nil)
    board_size = Math.sqrt(@values.length)
    rows = []
    left_to_right = []
    right_to_left = []
    won = false

    @values.each_slice(board_size).with_index do |row, index|
      left_to_right << row[index]
      right_to_left << row[(board_size-1)-index]
      rows << row
    end

    all_sets = rows + rows.transpose + [left_to_right] + [right_to_left]

    all_sets.each do |set|
      if set.uniq.length == 1
        if player
          won = true if set[0] == player.marker
        else
          won = true
        end
      end
    end

    return won
  end

  def tie?
    !won? && available_spaces.empty?
  end
end