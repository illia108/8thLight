require_relative 'board'
require_relative 'player'
require_relative 'view'

class Game
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
    @view = View.new
    @active_player = nil
    @opponent = nil
  end

  def start_game
    @view.welcome

    set_game_mode
    set_player_order
    select_markers

    @view.display_board(@board)

    play_game

    @view.game_over
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

  def set_player_order
    until @active_player
      first = @view.select_first_player(@player1, @player2)
      case first
      when "1"
        @active_player = @player1
        @opponent = @player2
      when "2"
        @active_player = @player2
        @opponent = @player1
      else
        @view.invalid_player
      end
    end
  end

  def select_markers
    until @active_player.marker && @opponent.marker
      set_marker
      switch_active_player
    end
  end

  def set_marker
    until @active_player.marker
      marker = @view.get_user_marker(@active_player)
      if marker == @opponent.marker
        @view.marker_in_use(@opponent)
      elsif /^\D$/ === marker
        @active_player.marker = marker
      else
        @view.invalid_marker
      end
    end
  end

  def play_game
    while true
      player_turn
      return if game_over?
      switch_active_player
    end
  end

  def switch_active_player
    if @active_player == @player1
      @active_player = @player2
      @opponent = @player1
    else
      @active_player = @player1
      @opponent = @player2
    end
  end

  def player_turn
    if @active_player.human
      get_user_move
    else
      get_computer_move
    end
  end

  def get_user_move
    @view.prompt_user_move(@active_player)
    spot = nil
    until spot
      spot = gets.chomp
      if valid_input?(spot)
        make_move(spot.to_i)
      else
        @view.invalid_move(@board)
        spot = nil
      end
    end
  end

  def valid_input?(spot)
    /^\d{1}$/ === spot && @board.available_spaces.include?(spot.to_i)
  end

  def get_computer_move
    sleep 1
    if @board.values[4] == 4
      make_move(4)
    else
      get_best_move(@board, @active_player)
      make_move(@choice)
    end
  end

  def make_move(spot)
    @board.update_board(@active_player.marker, spot)
    @view.display_board(@board)
    @view.commentary(@active_player, spot)
  end

  def score(board, depth)
    if board.has_been_won?(@active_player)
      return 10 - depth
    elsif board.has_been_won?(@opponent)
      return depth - 10
    else
      return 0
    end
  end

  def get_best_move(board, player, depth = 0)
    return score(board, depth) if board.has_been_won? || board.tie?
    depth += 1
    scores = {}

    board.available_spaces.each do |move|
      possible_board = board_copy(board)
      possible_board.update_board(player.marker, move)
      scores[move] = get_best_move(possible_board, next_player(player), depth)
    end

    if player == @active_player
      best_score = scores.max_by{|move, score| score}
      @choice = best_score[0]  #move
      return best_score[1]     #score
    else
      best_score = scores.min_by{|move, score| score}
      @choice = best_score[0]  #move
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
    return @player2 if current_player == @player1
    return @player1 if current_player == @player2
  end

  def game_over?
    if @board.has_been_won?(@active_player)
      @view.win(@active_player)
      return true
    end
    if @board.tie?
      @view.tie
      return true
    end
  end
end


