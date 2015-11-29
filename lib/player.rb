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
    if game.board.size.odd?
      center = (game.board.values.length) / 2
      if game.board.values[center] == center
        return center.to_s
      end
    end
    return Minmax.choice(game).to_s
  end

end
