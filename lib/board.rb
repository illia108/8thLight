class Board
  attr_reader :values, :available_spaces, :board_size

  def initialize(args = {})
    @board_size = args[:board_size] || 3

    if @board_size == 3
      @values = Array(0..8)
    elsif @board_size == 4
      @values = Array(0..15)
    elsif @board_size == 5
      @values = Array(0..24)
    else
      @values = Array(0..8)
    end

  end

  def available_spaces
    @values.select{|value| value.class == Fixnum}
  end

  def update_board(value, space)
    @values[space] = value
  end

  def won?(player = nil)
    rows = []
    left_to_right = []
    right_to_left = []
    won = false

    @values.each_slice(@board_size).with_index do |row, index|
      left_to_right << row[index]
      right_to_left << row[(@board_size-1)-index]
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