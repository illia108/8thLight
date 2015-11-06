require 'spec_helper'

describe Player do
  let(:player){ Player.new({name: "Player", human: true}) }
  let(:computer){ Player.new({name: "Computer", human: false}) }

  context "initialize" do
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

  context "human?" do
    it "should respond to human? method with boolean" do
      expect(player.human?).to eq(true)
      expect(computer.human?).to eq(false)
    end
  end
end