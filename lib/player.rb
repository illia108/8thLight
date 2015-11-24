require_relative 'minmax'

class Player
  attr_reader :name
  attr_accessor :marker

  def initialize(args)
    @marker = args[:marker]
    @name = args[:name]
  end

end

class HumanPlayer < Player
  def initialize(args)
    super
  end

  def pick_space(game)
    nil
  end
end

class AIPlayer < Player
  def initialize(args)
    super
  end

  def pick_space(game)
    # sleep 1
    if game.board.values[4] == 4
      return "4"
    else
      return Minmax.choice(game).to_s
    end
  end
end
