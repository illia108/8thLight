class Player
  attr_accessor :marker, :name, :human

  def initialize(args)
    @marker = args[:marker]
    @name = args[:name]
    @human = args[:human]
  end

  def human?
    @human
  end

end