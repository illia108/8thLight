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
  play_again? ? start_game : @view.game_over
end

def play_again?
  y_or_n = @view.play_again?
  case y_or_n.downcase
  when "y"
    return true
  when "n"
    return false
  else
    play_again?
  end
end

def set_game_mode
  @view.header
  while true
    mode = @view.select_game_mode
    break if @game.set_mode(mode)
    @view.invalid_mode
  end
end

def set_player_order
  @view.header
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
  @game.switch_active_player
end

def set_marker
  @view.header
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
    @game.active_player.human? ? get_user_move : get_computer_move
    break if game_over?
    @game.switch_active_player
  end
end

def get_user_move
  while true
    move = @view.prompt_user_move(@game.active_player)
    if @game.valid_move?(move)
      make_move(move.to_i)
      break
    else
      @view.invalid_move(@game.board)
    end
  end
end

def get_computer_move
  sleep 1
  make_move(@game.get_computer_move)
end

def make_move(space)
  @game.make_move(space)
  @view.display_board(@game.board)
  @view.commentary(@game.active_player, space)
end

def game_over?
  if @game.won?
    @view.win(@game.active_player)
    return true
  end
  if @game.tie?
    @view.tie
    return true
  end
end

start_game