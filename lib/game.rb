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

class View
  def welcome
    puts "Welcome to my Tic Tac Toe game"
  end

  def select_game_mode
    puts "What type of game would you like to play"
    puts "1) Human v Human"
    puts "2) Computer v Computer"
    puts "3) Human v Computer"
    return gets.chomp
  end

  def select_first_player(player1, player2)
    puts "Who will go first?"
    puts "1) #{player1.name}"
    puts "2) #{player2.name}"
    return gets.chomp
  end

  def get_user_marker(player)
    puts "Enter marker for #{player.name}"
    return gets.chomp
  end

  def display_board(board)
    puts [
      "",
      "  #{board.values[0]} | #{board.values[1]} | #{board.values[2]}",
      " ---|---|---",
      "  #{board.values[3]} | #{board.values[4]} | #{board.values[5]}",
      " ---|---|---",
      "  #{board.values[6]} | #{board.values[7]} | #{board.values[8]}",
      "",
    ].join("\n") + "\n"
  end

  def prompt_user_move(player)
    puts "#{player.name} (#{player.marker}): Please select your spot."
  end

  def invalid_move(board)
    puts "\e[31m"+"Please enter a valid value"+"\e[0m"
    puts "Valid values: #{board.available_spaces}"
  end

  def invalid_marker
    puts "\e[31m"+"Please enter a single non-digit character"+"\e[0m"
  end

  def commentary(player, spot)
    puts "\e[32m"+"#{player.name} (#{player.marker}) takes spot #{spot}"+"\e[0m"
  end

  def win
    puts "Game Won"
  end

  def tie
    puts "It's a Tie"
  end

  def game_over
    puts "End"
  end

  def clear
    system 'clear'
  end
end

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
