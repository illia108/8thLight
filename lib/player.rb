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

end