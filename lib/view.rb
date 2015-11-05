class View
  def welcome
    clear
    # puts "Welcome to my Tic Tac Toe game"
    puts [
      "  _________   |     _____    |     ______   ",
      " |  _   _  |  |    |_   _|   |   .' ___  |  ",
      " |_/ | | \\_|  |      | |     |  / .'   \\_|  ",
      "     | |      |      | |     |  | |         ",
      "    _| |_     |     _| |_    |  \\ `.___.'\\  ",
      "   |_____|    |    |_____|   |   `._____.'  ",
      "--------------'--------------'--------------",
      "  _________   |      __      |     ______   ",
      " |  _   _  |  |     /  \\     |   .' ___  |  ",
      " |_/ | | \\_|  |    / /\\ \\    |  / .'   \\_|  ",
      "     | |      |   / ____ \\   |  | |         ",
      "    _| |_     | _/ /    \\ \\_ |  \\ `.___.'\\  ",
      "   |_____|    ||____|  |____||   `._____.'  ",
      "--------------'--------------'--------------",
      "  _________   |     ____     |  _________   ",
      " |  _   _  |  |   .'    `.   | |_   ___  |  ",
      " |_/ | | \\_|  |  /  .--.  \\  |   | |_  \\_|  ",
      "     | |      |  | |    | |  |   |  _|  _   ",
      "    _| |_     |  \\  `--'  /  |  _| |___/ |  ",
      "   |_____|    |   `.____.'   | |_________|  ",
    ].join("\n") + "\n"
  sleep 0.5
end

  def select_game_mode
    sleep 0.5
    puts ""
    puts "What type of game would you like to play?"
    puts "1) Human v. Human"
    puts "2) Computer v. Computer"
    puts "3) Human v. Computer"
    return gets.chomp
  end

  def select_first_player(player1, player2)
    sleep 0.5
    puts ""
    puts "Who will go first?"
    puts "1) #{player1.name} '#{player1.marker}'"
    puts "2) #{player2.name} '#{player2.marker}'"
    return gets.chomp
  end

  def get_user_marker(player)
    sleep 0.5
    puts ""
    puts "Enter a marker for #{player.name}"
    return gets.chomp
  end

  def display_board(board)
    clear
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
    puts "#{player.name} '#{player.marker}': Please select your spot."
  end

  def invalid_mode
    puts ""
    puts "\e[31m"+"Please enter a valid mode value"+"\e[0m"
    puts "Valid values: 1, 2, 3"
  end

  def invalid_player
    puts ""
    puts "\e[31m"+"Please enter a valid player value"+"\e[0m"
    puts "Valid values: 1, 2"
  end

  def invalid_move(board)
    puts ""
    puts "\e[31m"+"Please enter a valid value"+"\e[0m"
    puts "Valid values: #{board.available_spaces}"
  end

  def marker_in_use(player)
    puts ""
    puts "\e[31m"+"#{player.name} is using this marker, please choose another"+"\e[0m"
  end

  def invalid_marker
    puts ""
    puts "\e[31m"+"Please enter a single non-digit character"+"\e[0m"
  end

  def commentary(player, spot)
    puts "\e[32m"+"#{player.name} '#{player.marker}' takes spot #{spot}"+"\e[0m"
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