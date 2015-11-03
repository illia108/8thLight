class Game
  def initialize
    @board = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @available_spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @computer = "\e[33mX\e[0m"
    @human = "\e[32mO\e[0m"
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
    puts "|_#{@board[0]}_|_#{@board[1]}_|_#{@board[2]}_|\n|_#{@board[3]}_|_#{@board[4]}_|_#{@board[5]}_|\n|_#{@board[6]}_|_#{@board[7]}_|_#{@board[8]}_|\n"
    # puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n___|___|___\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n___|___|___\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n   |   |   \n"
  end

  def get_user_move
    puts "Please select your spot."
    spot = nil
    until spot
      spot = gets.chomp.to_i
      if @available_spaces.include?(spot)
        make_move(spot, @human)
      else
        spot = nil
      end
    end
  end

  def get_computer_move
    if @board[4] == 4
      make_move(4, @computer)
    else
      spot = get_best_move(@board.clone, @computer)
      make_move(spot, @computer)
    end
  end

  def make_move(spot, player)
    @board[spot] = player
    @available_spaces.delete(spot)
    display_board
    p "#{player} takes spot #{spot}"
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    @available_spaces.each do |space|
      board[space] = @computer
      if game_is_over?(board)
        return space
      else
        board[space] = @human
        if game_is_over?(board)
          return space
        else
          board[space] = space
        end
      end
    end
    return @available_spaces.sample
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
