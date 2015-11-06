class Board
  attr_accessor :values, :available_spaces

  def initialize
    @values = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @available_spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  end

  def update_board(value, position)
    @values[position] = value
    @available_spaces.delete(position)
  end

  def has_been_won?
    # [@values[0], @values[1], @values[2]].uniq.length == 1 ||
    # [@values[3], @values[4], @values[5]].uniq.length == 1 ||
    # [@values[6], @values[7], @values[8]].uniq.length == 1 ||
    # [@values[0], @values[3], @values[6]].uniq.length == 1 ||
    # [@values[1], @values[4], @values[7]].uniq.length == 1 ||
    # [@values[2], @values[5], @values[8]].uniq.length == 1 ||
    # [@values[0], @values[4], @values[8]].uniq.length == 1 ||
    # [@values[2], @values[4], @values[6]].uniq.length == 1
    tic_tac_toes = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ]
    tic_tac_toes.each do |row|
      # next if row.any? {|cell| @available_spaces.include?(cell)}
      return true if [@values[row[0]], @values[row[1]], @values[row[2]]].uniq.length == 1
    end
    return false
  end

  def tie?
    @available_spaces.empty?
  end
end