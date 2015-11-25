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
    if board.won? || board.tie? || depth == ([2, 7 - board.size].max)
      return score(board, depth)
    end

    depth += 1
    scores = {}

    if player == @game.active_player
      board.available_spaces.each do |space|
        possible_board = new_game_state(board, player, space)
        scores[space] = get_best_move(possible_board, next_player(player), depth, min, max)
        min = [scores[space], min].max
        return max if min > max
      end
      best_score = scores.max_by{|space, score| score}
    else
      board.available_spaces.each do |space|
        possible_board = new_game_state(board, player, space)
        scores[space] = get_best_move(possible_board, next_player(player), depth, min, max)
        max = [scores[space], max].min
        return min if max < min
      end
      best_score = scores.min_by{|space, score| score}
    end

    @choice = best_score[0]  #space
    return best_score[1]     #score
  end

  def self.new_game_state(board, player, space)
    temp_board = board_copy(board)
    temp_board.update_board(player.marker, space)
    temp_board
  end

  def self.board_copy(board)
    temp_board = Board.new({size: board.size})

    board.values.each_with_index do |value, index|
      temp_board.update_board(value, index)
    end

    return temp_board
  end

  def self.next_player(current_player)
    current_player == @game.active_player ? @game.opponent : @game.active_player
  end
end