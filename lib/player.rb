require_relative 'minmax'

class Player
  attr_reader :name, :human
  attr_accessor :marker

  def initialize(args)
    @marker = args[:marker]
    @name = args[:name]
    @human = args[:human]
  end

  def human?
    @human
  end

  def pick_space(game)
    if human?
      return gets.chomp
    else
      sleep 0.5
      if game.board.values[4] == 4
        return "4"
      else
        return Minmax.choice(game).to_s
      end
    end
  end

end