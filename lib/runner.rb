require_relative "game"
require_relative 'board'
require_relative 'view'


def start_game
  @game = Game.new
  @view = View.new
  @view.welcome
  set_game_mode
  set_player_order
  select_markers
  play_game
end

def set_game_mode
  while true
    mode = @view.select_game_mode
    break if @game.set_mode(mode)
    @view.invalid_mode
  end
end

def set_player_order
  while true
    first = @view.select_first_player(@game.active_player, @game.opponent)
    break if @game.set_player_order(first)
    @view.invalid_player
  end
end

def select_markers
  set_marker
  @game.switch_active_player
  set_marker
end

def set_marker
  until @game.active_player.marker
    marker = @view.get_user_marker(@game.active_player)
    if marker == @game.opponent.marker
      @view.marker_in_use(@game.opponent)
    elsif /^\D$/ === marker
      @game.active_player.marker = marker
    else
      @view.invalid_marker
    end
  end
end

def play_game
  @view.display_board(@game.board)
  while true
    player_turn
    break if game_over?
    @game.switch_active_player
  end
  @view.game_over
end

def player_turn
  if @game.active_player.human?
    get_user_move
  else
    get_computer_move
  end
end

def get_user_move
  while true
    move = @view.prompt_user_move(@game.active_player)
    if valid_input?(move)
      make_move(move.to_i)
      break
    else
      @view.invalid_move(@game.board)
    end
  end
end

def valid_input?(space)
  /^\d{1}$/ === space && @game.board.available_spaces.include?(space.to_i)
end

def get_computer_move
  sleep 1
  if @game.board.values[4] == 4
    make_move(4)
  else
    get_best_move(@game.board, @game.active_player)
    make_move(@choice)
  end
end

def make_move(space)
  @game.board.update_board(@game.active_player.marker, space)
  @view.display_board(@game.board)
  @view.commentary(@game.active_player, space)
end

def score(board, depth)
  if board.won?(@game.active_player)
    return 10 - depth
  elsif board.won?(@game.opponent)
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

def board_copy(board)
  temp_board = Board.new
  temp_board.values = board.values.clone
  temp_board.available_spaces = board.available_spaces.clone
  return temp_board
end

def next_player(current_player)
  current_player == @game.active_player ? @game.opponent : @game.active_player
end

def game_over?
  if @game.board.won?(@game.active_player)
    @view.win(@game.active_player)
    return true
  end
  if @game.board.tie?
    @view.tie
    return true
  end
end

start_game