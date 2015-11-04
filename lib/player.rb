class Player
  attr_accessor :marker, :name, :human

  def initialize(args)
    @marker = nil
    @name = args[:name]
    @human = args[:human]
  end

end