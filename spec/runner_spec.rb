require 'spec_helper'

describe "runner" do
  let(:game){ Game.new }
  let(:playerX){ Player.new({marker: "X"}) }
  let(:playerO){ Player.new({marker: "O"}) }

  context "#get_best_move" do

    it "should set choice to the winning move" do
      game.board.values = ["X", "X", 2, 3, "O", "O", "O", 7, 8]
      game.active_player = playerX
      game.opponent = playerO
      # get_best_move(game.board, playerX)

    end
  end
end