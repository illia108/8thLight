class Game
  def initialize
    @board = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @computer = "X"
    @human = "O"
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game"
    display_board
    puts "Please select your spot."
    until game_is_over?(@board) || tie?(@board)
      get_human_spot
      if !game_is_over?(@board) && !tie?(@board)
        eval_board
      end
      display_board
    end
    puts "Game over"
  end

  def display_board
    puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @board[spot] != "X" && @board[spot] != "O"
        @board[spot] = @human
      else
        spot = nil
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      if @board[4] == 4
        spot = 4
        @board[spot] = @computer
      else
        spot = get_best_move(@board, @computer)
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @computer
        else
          spot = nil
        end
      end
    end
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    available_spaces = []
    best_move = nil
    board.each do |space|
      if space != "X" && space != "O"
        available_spaces << space
      end
    end
    available_spaces.each do |space|
      board[space] = @computer
      if game_is_over?(board)
        best_move = space
        board[space] = space
        return best_move
      else
        board[space] = @human
        if game_is_over?(board)
          best_move = space
          board[space] = space
          return best_move
        else
          board[space] = space
        end
      end
    end
    if best_move
      return best_move
    else
      random = rand(0..available_spaces.count)
      return available_spaces[random].to_i
    end
  end

  def game_is_over?(board)

    [board[0], board[1], board[2]].uniq.length == 1 ||
    [board[3], board[4], board[5]].uniq.length == 1 ||
    [board[6], board[7], board[8]].uniq.length == 1 ||
    [board[0], board[3], board[6]].uniq.length == 1 ||
    [board[1], board[4], board[7]].uniq.length == 1 ||
    [board[2], board[5], board[8]].uniq.length == 1 ||
    [board[0], board[4], board[8]].uniq.length == 1 ||
    [board[2], board[4], board[6]].uniq.length == 1
  end

  def tie?(board)
    board.all? { |space| space == "X" || space == "O" }
  end

end

game = Game.new
game.start_game
