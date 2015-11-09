class View

  def ascii_art
    [
      "\e[32m _______ _   _______      _______         ",
      "|__   __(_) |__   __|    |__   __|        ",
      "   | |   _  ___| | __ _  ___| | ___   ___ ",
      "   | |  | |/ __| |/ _` |/ __| |/ _ \\ / _ \\",
      "   | |  | | (__| | (_| | (__| | (_) |  __/",
      "   |_|  |_|\\___|_|\\__,_|\\___|_|\\___/ \\___|",
      "",
    ].join("\n") + "\e[0m\n"
  end

  def welcome
    clear
    ascii_art.each_char do |char|
      print char
      sleep 0.005
    end
    sleep 0.5
  end

  def header
    clear
    puts ascii_art
  end

  def select_game_mode
    sleep 0.5
    puts "What type of game would you like to play?"
    puts "[#{red(1)}] Human v. Human"
    puts "[#{red(2)}] Computer v. Computer"
    puts "[#{red(3)}] Human v. Computer"
    return gets.chomp
  end

  def red(text)
    "\e[31m#{text}\e[0m"
  end

  def green(text)
    "\e[32m#{text}\e[0m"
  end

  def select_first_player(player1, player2)
    sleep 0.5
    puts "Who will go first?"
    puts "[#{red(1)}] #{player1.name}"
    puts "[#{red(2)}] #{player2.name}"
    return gets.chomp
  end

  def get_user_marker(player)
    sleep 0.5
    puts "Please enter a marker (X, O or any letter) for #{player.name}"
    return gets.chomp
  end

  def display_board(board)
    header
    pretty_board = [
      "         #{board.values[0]} | #{board.values[1]} | #{board.values[2]}",
      "        ---|---|---",
      "         #{board.values[3]} | #{board.values[4]} | #{board.values[5]}",
      "        ---|---|---",
      "         #{board.values[6]} | #{board.values[7]} | #{board.values[8]}",
    ].join("\n") + "\n"
    puts pretty_board.gsub(/([a-zA-Z])/){ |marker| green(marker)}
  end

  def prompt_user_move(player)
    puts ""
    puts "#{player.name} '#{player.marker}': Please enter the number of the cell you would like to take."
    return gets.chomp
  end

  def invalid_mode
    puts ""
    puts red("Please enter a valid mode value")
    puts "Valid values: 1, 2, 3"
  end

  def invalid_player
    puts ""
    puts red("Please enter a valid player value")
    puts "Valid values: 1, 2"
  end

  def invalid_move(board)
    puts ""
    puts red("Please enter a valid value")
    puts "Valid values: #{board.available_spaces}"
  end

  def marker_in_use(player)
    puts ""
    puts red("#{player.name} is using this marker, please choose another")
  end

  def invalid_marker
    puts ""
    puts red("Please enter a single non-digit character")
  end

  def commentary(player, space)
    puts ""
    puts "\e[32m"+"#{player.name} '#{player.marker}' takes position #{space}"+"\e[0m"
  end

  def win(player)
    puts ""
    puts "#{player.name} Wins!"
  end

  def tie
    puts ""
    puts "It's a Tie!"
  end

  def play_again?
    puts ""
    puts "Would you like to play again?"
    puts "[#{red("Y/N")}]"
    return gets.chomp
  end

  def game_over
    puts ""
    puts "Thanks for playing!"
  end

  def clear
    system 'clear'
  end
end