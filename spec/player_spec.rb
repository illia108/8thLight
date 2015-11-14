require 'spec_helper'

describe Player do
  let(:player){ Player.new({name: "Player", human: true}) }
  let(:computer){ Player.new({name: "Computer", human: false}) }
  let(:game){ Game.new }

  context "#initialize" do
    it "should be a Player" do
      expect(player).to be_a(Player)
      expect(computer).to be_a(Player)
    end
    it "should have a name" do
      expect(player.name).to eq("Player")
      expect(computer.name).to eq("Computer")
    end
    it "should have a boolean value for human" do
      expect(player.human).to eq(true)
      expect(computer.human).to eq(false)
    end
    it "should have marker == nil" do
      expect(player.marker).to be_nil
      expect(computer.marker).to be_nil
    end
  end

  context "#human?" do
    it "should respond to human? method with boolean" do
      expect(player.human?).to eq(true)
      expect(computer.human?).to eq(false)
    end
  end

  context "#pick_space" do
    before {
      game.board.update_board("X", 0)

      game.set_mode("2")
      game.active_player.marker = "X"
      game.opponent.marker = "O"
    }
    it "should return the center position if open" do
      expect(game.active_player.pick_space(game)).to eq "4"
      game.switch_active_player
      expect(game.active_player.pick_space(game)).to eq "4"
    end
    it "should call Minmax.choice if center is taken" do
      game.board.update_board("O", 4)

      expect(Minmax).to receive(:choice).with(game)
      game.active_player.pick_space(game)
      # game.get_computer_move
    end
  end
end