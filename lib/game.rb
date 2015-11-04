class Board
  attr_accessor :values, :available_spaces

  def initialize
    @values = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @available_spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  end

  def update_board(value, position)
    @values[position] = "\e[32m#{value}\e[0m"
    @available_spaces.delete(position)
  end
end

class Game
  def initialize
    @board = Board.new
    @computer = "X"
    @human = "O"
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game"
    display_board

    until game_is_over?(@board) || tie?(@board)
      get_user_move
      if !game_is_over?(@board) && !tie?(@board)
        get_computer_move
      end
    end
    puts "Game over"
  end

  def display_board
    puts "|_#{@board.values[0]}_|_#{@board.values[1]}_|_#{@board.values[2]}_|\n|_#{@board.values[3]}_|_#{@board.values[4]}_|_#{@board.values[5]}_|\n|_#{@board.values[6]}_|_#{@board.values[7]}_|_#{@board.values[8]}_|\n"
    # puts " #{@board.values[0]} | #{@board.values[1]} | #{@board.values[2]} \n___|___|___\n #{@board.values[3]} | #{@board.values[4]} | #{@board.values[5]} \n___|___|___\n #{@board.values[6]} | #{@board.values[7]} | #{@board.values[8]} \n   |   |   \n"
  end

  def get_user_move
    puts "Please select your spot."
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board.available_spaces.include?(spot)
        make_move(spot, @human)
      else
        spot = nil
      end
    end
  end

  def get_computer_move
    if @board.values[4] == 4
      make_move(4, @computer)
    else
      spot = get_best_move(@board.clone, @computer)
      make_move(spot, @computer)
    end
  end

  def make_move(spot, player)
    @board.update_board(player, spot)
    display_board
    p "#{player} takes spot #{spot}"
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    board.available_spaces.each do |space|
      board.values[space] = @computer
      if game_is_over?(board)
        return space
      else
        board.values[space] = @human
        if game_is_over?(board)
          return space
        else
          board.values[space] = space
        end
      end
    end
    return board.available_spaces.sample
  end

  def game_is_over?(board)

    [board.values[0], board.values[1], board.values[2]].uniq.length == 1 ||
    [board.values[3], board.values[4], board.values[5]].uniq.length == 1 ||
    [board.values[6], board.values[7], board.values[8]].uniq.length == 1 ||
    [board.values[0], board.values[3], board.values[6]].uniq.length == 1 ||
    [board.values[1], board.values[4], board.values[7]].uniq.length == 1 ||
    [board.values[2], board.values[5], board.values[8]].uniq.length == 1 ||
    [board.values[0], board.values[4], board.values[8]].uniq.length == 1 ||
    [board.values[2], board.values[4], board.values[6]].uniq.length == 1
  end

  def tie?(board)
    board.values.all? { |space| space == "X" || space == "O" }
  end

end

game = Game.new
game.start_game
