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
      if game.board.size.odd?
        center = (game.board.values.length) / 2
        if game.board.values[center] == center
          return center.to_s
        end
      end
      return Minmax.choice(game).to_s
    end
  end

end