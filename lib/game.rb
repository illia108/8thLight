require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board, :active_player, :opponent

  def initialize
    @board = Board.new
  end

  def set_mode(mode)
    case mode
    when '1'
      @active_player = HumanPlayer.new({name: "Player1"})
      @opponent = HumanPlayer.new({name: "Player2"})
    when '2'
      @active_player = AIPlayer.new({name: "Computer1"})
      @opponent = AIPlayer.new({name: "Computer2"})
    when '3'
      @active_player = HumanPlayer.new({name: "Player"})
      @opponent = AIPlayer.new({name: "Computer"})
    else
      return false
    end
    return true
  end

  def set_player_order(first)
    case first
    when "1"
      # do nothing
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

  def make_move(space)
    @board.update_board(@active_player.marker, space)
  end

  def valid_move?(space)
    /^\d{1}$/ === space && @board.available_spaces.include?(space.to_i)
  end

  def won?
    @board.won?(@active_player)
  end

  def tie?
    @board.tie?
  end

end


