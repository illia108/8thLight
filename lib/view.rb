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

  def get_input
    gets.chomp
  end

  def select_size
    sleep 0.5
    puts "What size board would you like to use?"
    puts "[#{red(1)}] 3x3"
    puts "[#{red(2)}] 4x4"
    puts "[#{red(3)}] 5x5"
    puts "[#{red(4)}] 6x6"
    gets.chomp
  end

  def select_game_mode
    sleep 0.5
    puts "What type of game would you like to play?"
    puts "[#{red(1)}] Human v. Human"
    puts "[#{red(2)}] Computer v. Computer"
    puts "[#{red(3)}] Human v. Computer"
    gets.chomp
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
    gets.chomp
  end

  def get_user_marker(player)
    sleep 0.5
    puts "Please enter a marker (X, O or any letter) for #{player.name}"
    gets.chomp
  end

  def display_board(board)
    header

    pretty_board = []
    spacer = []
    board.values.each_slice(board.size) do |row|
      row[0] = " #{row[0]}"
      pretty_board << row.join(" | ")
      spacer << "----"
    end

    pretty_board = pretty_board.join("\n#{spacer.join("|")}\n") + "\n"
    pretty_board.gsub!(/\s\w{1}\s/){ |space| " #{space}"}
    pretty_board.gsub!(/([a-zA-Z])/){ |marker| green(marker)}
    puts pretty_board
  end

  def prompt_user_move(player)
    puts "\n#{player.name} '#{player.marker}': Please enter the number of the cell you would like to take."
  end

  def invalid_size
    puts red("\nPlease enter a valid board size")
    puts "Valid values: 1, 2, 3"
  end

  def invalid_mode
    puts red("\nPlease enter a valid mode value")
    puts "Valid values: 1, 2, 3"
  end

  def invalid_player
    puts red("\nPlease enter a valid player value")
    puts "Valid values: 1, 2"
  end

  def invalid_move(board)
    puts red("\nPlease enter a valid value")
    puts "Valid values: #{board.available_spaces}"
  end

  def marker_in_use(player)
    puts red("\n#{player.name} is using this marker, please choose another")
  end

  def invalid_marker
    puts red("\nPlease enter a single non-digit character")
  end

  def commentary(player, space)
    puts "\n\e[32m"+"#{player.name} '#{player.marker}' takes position #{space}"+"\e[0m"
  end

  def win(player)
    puts "\n#{player.name} Wins!"
  end

  def tie
    puts "\nIt's a Tie!"
  end

  def play_again?
    puts "\nWould you like to play again?"
    puts "[#{red("Y/n")}]"
    gets.chomp
  end

  def game_over
    puts "\nThanks for playing!"
  end

  def clear
    system 'clear'
  end
end
