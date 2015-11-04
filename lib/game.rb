class Board
  attr_accessor :values, :available_spaces

  def initialize
    @values = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    @available_spaces = [0, 1, 2, 3, 4, 5, 6, 7, 8]
  end

  def update_board(value, position)
    @values[position] = value
    @available_spaces.delete(position)
  end

  def has_been_won?
    [@values[0], @values[1], @values[2]].uniq.length == 1 ||
    [@values[3], @values[4], @values[5]].uniq.length == 1 ||
    [@values[6], @values[7], @values[8]].uniq.length == 1 ||
    [@values[0], @values[3], @values[6]].uniq.length == 1 ||
    [@values[1], @values[4], @values[7]].uniq.length == 1 ||
    [@values[2], @values[5], @values[8]].uniq.length == 1 ||
    [@values[0], @values[4], @values[8]].uniq.length == 1 ||
    [@values[2], @values[4], @values[6]].uniq.length == 1
  end

  def tie?
    # @values.all? { |space| space == "X" || space == "O" }
    @available_spaces.empty?
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

    while true
      get_user_move
      break if game_over?
      get_computer_move
      break if game_over?
    end

    puts "End"
  end

  def game_over?
    if @board.has_been_won?
      puts "Game Won"
      return true
    end
    if @board.tie?
      puts "It's a Tie"
      return true
    end
  end

  def display_board
    puts [
      "",
      "  #{@board.values[0]} | #{@board.values[1]} | #{@board.values[2]}",
      " ---|---|---",
      "  #{@board.values[3]} | #{@board.values[4]} | #{@board.values[5]}",
      " ---|---|---",
      "  #{@board.values[6]} | #{@board.values[7]} | #{@board.values[8]}",
      "",
      ].join("\n") + "\n"
  end

  def get_user_move
    puts "Please select your spot."
    spot = nil
    until spot
      spot = gets.chomp
      if /^\d{1}$/ === spot && @board.available_spaces.include?(spot.to_i)
        make_move(spot.to_i, @human)
      else
        puts "\e[31m"+"Please enter a valid value"+"\e[0m"
        puts "Valid values: #{@board.available_spaces}"
        spot = nil
      end
    end
  end

  def get_computer_move
    if @board.values[4] == 4
      sleep 1
      make_move(4, @computer)
    else
      spot = get_best_move(@board.clone, @computer)
      sleep 1
      make_move(spot, @computer)
    end
  end

  def make_move(spot, player)
    @board.update_board(player, spot)
    display_board
    puts "\e[32m"+"#{player} takes spot #{spot}"+"\e[0m"
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    board.available_spaces.each do |space|
      board.values[space] = @computer
      # board.update_board(@computer, space)
      if board.has_been_won?
        return space
      else
        board.values[space] = @human
        # board.update_board(@human, space)
        if board.has_been_won?
          return space
        else
          board.values[space] = space
        end
      end
    end
    return board.available_spaces.sample
  end
end

game = Game.new
game.start_game
