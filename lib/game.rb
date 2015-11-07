require_relative 'board'
require_relative 'player'

class Game
  attr_accessor :board, :active_player, :opponent

  def initialize
    @board = Board.new
  end

  def set_mode(mode)
    case mode
    when '1'
      @active_player = Player.new({name: "Player1", human: true})
      @opponent = Player.new({name: "Player2", human: true})
    when '2'
      @active_player = Player.new({name: "Computer1", human: false})
      @opponent = Player.new({name: "Computer2", human: false})
    when '3'
      @active_player = Player.new({name: "Player", human: true})
      @opponent = Player.new({name: "Computer", human: false})
    else
      return false
    end
    return true
  end

  def set_player_order(first)
    case first
    when "1"
    when "2"
      switch_active_player
    else
      return false
    end
    return true
  end

  def switch_active_player
    @active_player, @opponent = @opponent, @active_player
  end

  def get_computer_move
    if @board.values[4] == 4
      return 4
    else
      get_best_move(@board, @active_player)
      return @choice
    end
  end

  def make_move(space)
    @board.update_board(@active_player.marker, space)
  end

  def valid_move?(space)
    /^\d{1}$/ === space && @board.available_spaces.include?(space.to_i)
  end

  def score(board, depth)
    if board.won?(@active_player)
      return 10 - depth
    elsif board.won?(@opponent)
      return depth - 10
    else
      return 0
    end
  end

  def get_best_move(board, player, depth = 0)
    return score(board, depth) if board.won? || board.tie?
    depth += 1
    scores = {}

    board.available_spaces.each do |space|
      possible_board = board_copy(board)
      possible_board.update_board(player.marker, space)
      scores[space] = get_best_move(possible_board, next_player(player), depth)
    end

    if player == @active_player
      best_score = scores.max_by{|space, score| score}
      @choice = best_score[0]  #space
      return best_score[1]     #score
    else
      best_score = scores.min_by{|space, score| score}
      @choice = best_score[0]  #space
      return best_score[1]     #score
    end
  end

  def board_copy(board)
    temp_board = Board.new
    temp_board.values = board.values.clone
    temp_board.available_spaces = board.available_spaces.clone
    return temp_board
  end

  def next_player(current_player)
    current_player == @active_player ? @opponent : @active_player
  end

  def won?
    @board.won?(@active_player)
  end

  def tie?
    @board.tie?
  end

end


