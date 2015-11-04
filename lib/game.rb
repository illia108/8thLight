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

class Player
  attr_accessor :marker, :name, :human

  def initialize(args)
    @marker = nil
    @name = args[:name]
    @human = args[:human]
  end

  def set_marker
    until @marker
      puts "Enter marker for #{@name}"
      marker = gets.chomp
      if /^\D$/ === marker
        @marker = marker
      else
        puts "\e[31m"+"Please enter a single non-digit character"+"\e[0m"
      end
    end
  end
end

class Game
  def initialize
    @board = Board.new
    @player1 = nil
    @player2 = nil
  end

  def start_game
    puts "Welcome to my Tic Tac Toe game"
    mode = select_game_mode
    set_game_mode(mode)
    select_markers
    first = select_first_player
    set_first_player(first)
    p @player1
    p @player2
    display_board

    while true
      get_user_move
      break if game_over?
      get_computer_move
      break if game_over?
    end

    puts "End"
  end

  def select_game_mode
    puts "What type of game would you like to play"
    puts "1) Human v Human"
    puts "2) Computer v Computer"
    puts "3) Human v Computer"
    return gets.chomp
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
    @player1.set_marker
    @player2.set_marker
  end

  def select_first_player
    puts "Who will go first?"
    puts "1) #{@player1.name}"
    puts "2) #{@player2.name}"
    return gets.chomp
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
      if valid_input?(spot)
        make_move(spot.to_i, @player1.marker)
      else
        puts "\e[31m"+"Please enter a valid value"+"\e[0m"
        puts "Valid values: #{@board.available_spaces}"
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
      make_move(4, @player2.marker)
    else
      spot = get_best_move(@board.clone, @player2.marker)
      make_move(spot, @player2.marker)
    end
  end

  def make_move(spot, player)
    system 'clear'
    @board.update_board(player, spot)
    display_board
    puts "\e[32m"+"#{player} takes spot #{spot}"+"\e[0m"
  end

  def get_best_move(board, next_player, depth = 0, best_score = {})
    board.available_spaces.each do |space|
      board.values[space] = @player2.marker
      # board.update_board(@player2.marker, space)
      if board.has_been_won?
        return space
      else
        board.values[space] = @player1.marker
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
end

game = Game.new
game.start_game
