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

  def self.get_best_move(board, player, depth = 0)
    return score(board, depth) if board.won? || board.tie?
    depth += 1
    scores = {}

    board.available_spaces.each do |space|
      possible_board = board_copy(board)
      possible_board.update_board(player.marker, space)
      scores[space] = get_best_move(possible_board, next_player(player), depth)
    end

    if player == @game.active_player
      best_score = scores.max_by{|space, score| score}
      @choice = best_score[0]  #space
      return best_score[1]     #score
    else
      best_score = scores.min_by{|space, score| score}
      @choice = best_score[0]  #space
      return best_score[1]     #score
    end
  end

  def self.board_copy(board)
    temp_board = Board.new
    temp_board.values = board.values.clone
    temp_board.available_spaces = board.available_spaces.clone
    return temp_board
  end

  def self.next_player(current_player)
    current_player == @game.active_player ? @game.opponent : @game.active_player
  end
end