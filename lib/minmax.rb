module Minmax
  @game = nil

  def self.game=(game)
    @game = game
  end

  def self.choice(game)
    @game = game
    get_best_move(@game.board, @game.active_player)
    return @choice
  end

  def self.score(board, depth)
    if board.won?(@game.active_player)
      return 10 - depth
    elsif board.won?(@game.opponent)
      return depth - 10
    else
      return 0
    end
  end

  def self.get_best_move(board, player, depth = 0, min = -Float::INFINITY, max = Float::INFINITY)
    if (board.won? || board.tie?) || depth == (7 - board.board_size)
      return score(board, depth)
    end
    depth += 1

    if player == @game.active_player
      value = min
      board.available_spaces.each do |space|
        possible_board = board_copy(board)
        possible_board.update_board(player.marker, space)
        score = get_best_move(possible_board, next_player(player), depth, value, max)

        if score > value
          @choice = space
          value = score
        end

        return max if value > max
      end
      return value
    else
      value = max
      board.available_spaces.each do |space|
        possible_board = board_copy(board)
        possible_board.update_board(player.marker, space)
        score = get_best_move(possible_board, next_player(player), depth, min, value)

        if score < value
          @choice = space
          value = score
        end

        return min if value < min
      end
      return value
    end
  end

  def self.board_copy(board)
    temp_board = Board.new({board_size: board.board_size})

    board.values.each_with_index do |value, index|
      temp_board.update_board(value, index)
    end

    return temp_board
  end

  def self.next_player(current_player)
    current_player == @game.active_player ? @game.opponent : @game.active_player
  end
end