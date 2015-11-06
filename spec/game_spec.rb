require 'spec_helper'

describe Game do
  let(:game){ Game.new }
  let(:values){ [0,1,2,3,4,5,6,7,8] }

  context "initialize" do
    it "should be a Game" do
      expect(game).to be_a(Game)
    end

    it "should generate a board" do
      expect(game.board).to be_a(Board)
    end

    it "board should be empty" do
      expect(game.board.values).to eq(values)
    end

    it "board.available_spaces should contain all spaces" do
      expect(game.board.available_spaces).to eq(values)
    end

    it "should generate a view" do
      expect(game.view).to be_a(View)
    end

    it "should generate nil variables" do
      expect(game.player1).to be_nil
      expect(game.player2).to be_nil
      expect(game.active_player).to be_nil
      expect(game.opponent).to be_nil
    end
  end
end