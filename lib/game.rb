require_relative 'board'
require_relative 'player'
require_relative 'view'

class Game
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @view = View.new
  end

  def start_game
    @view.welcome

    mode = @view.select_game_mode
    set_game_mode(mode)

    select_markers

    first = @view.select_first_player(@player1, @player2)
    set_first_player(first)

    @view.display_board(@board)

    while true
      player_turn(@first_player)
      break if game_over?
      player_turn(@second_player)
      break if game_over?
    end
    @view.game_over
  end

  def player_turn(player)
    if player.human
      get_user_move(player)
    else
      get_computer_move(player)
    end
  end

  def set_game_mode(mode)
    case mode
    when '1'
      @player1 = Player.new({name: "Player1", human: true})
      @player2 = Player.new({name: "Player2", human: true})
    when '2'
      @player1 = Player.new({name: "Computer1", human: false})
      @player2 = Player.new({name: "Computer2", human: false})
    when '3'
      @player1 = Player.new({name: "Player", human: true})
      @player2 = Player.new({name: "Computer", human: false})
    end
  end

  def select_markers
    set_marker(@player1)
    set_marker(@player2)
  end

  def set_marker(player)
    until player.marker
      marker = @view.get_user_marker(player)
      if /^\D$/ === marker
        player.marker = marker
      else
        @view.invalid_marker
      end
    end
  end

  def set_first_player(first)
    case first
    when "1"
      @first_player = @player1
      @second_player = @player2
    when "2"
      @first_player = @player2
      @second_player = @player1
    end

  end

  def game_over?
    if @board.has_been_won?
      @view.win
      return true
    end
    if @board.tie?
      @view.tie
      return true
    end
  end

  def get_user_move(player)
    @view.prompt_user_move(player)
    spot = nil
    until spot
      spot = gets.chomp
      if valid_input?(spot)
        make_move(spot.to_i, player)
      else
        @view.invalid_move(@board)
        spot = nil
      end
    end
  end

  def valid_input?(spot)
    /^\d{1}$/ === spot && @board.available_spaces.include?(spot.to_i)
  end

  def get_computer_move(player)
    sleep 1
    if @board.values[4] == 4
      make_move(4, player)
    else
      spot = get_best_move(@board.clone, player)
      make_move(spot, player)
    end
  end

  def make_move(spot, player)
    @view.clear
    @board.update_board(player.marker, spot)
    @view.display_board(@board)
    @view.commentary(player, spot)
  end

  def get_best_move(board, player, depth = 0, best_score = {})
    board.available_spaces.each do |space|
      board.values[space] = player.marker
      # board.update_board(@player2.marker, space)
      if board.has_been_won?
        return space
      else
        board.values[space] = other_player(player).marker
        # board.update_board(@player1.marker, space)
        if board.has_been_won?
          return space
        else
          board.values[space] = space
        end
      end
    end
    return board.available_spaces.sample
  end

  def other_player(current_player)
    return @player2 if current_player == @player1
    return @player1 if current_player == @player2
  end
end

game = Game.new
game.start_game
