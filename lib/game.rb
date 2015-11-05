require_relative 'board'
require_relative 'player'
require_relative 'view'

class Game
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @view = View.new
    @first_player = nil
    @second_player = nil
  end

  def start_game
    @view.welcome

    set_game_mode
    select_markers
    set_player_order

    @view.display_board(@board)

    play_game

    @view.game_over
  end

  def play_game
    while true
      player_turn(@first_player)
      return if game_over?
      player_turn(@second_player)
      return if game_over?
    end
  end

  def player_turn(player)
    if player.human
      get_user_move(player)
    else
      get_computer_move(player)
    end
  end

  def set_game_mode
    until @player1
      mode = @view.select_game_mode
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
      else
        @view.invalid_mode
      end
    end
  end

  def select_markers
    set_marker(@player1)
    set_marker(@player2)
  end

  def set_marker(player)
    until player.marker
      marker = @view.get_user_marker(player)
      if marker == other_player(player).marker
        @view.marker_in_use(other_player(player))
      elsif /^\D$/ === marker
        player.marker = marker
      else
        @view.invalid_marker
      end
    end
  end

  def set_player_order
    until @first_player
      first = @view.select_first_player(@player1, @player2)
      case first
      when "1"
        @first_player = @player1
        @second_player = @player2
      when "2"
        @first_player = @player2
        @second_player = @player1
      else
        @view.invalid_player
      end
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
    # @view.clear
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


