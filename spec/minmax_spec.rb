require 'spec_helper'

describe Minmax do
  let(:game){ Game.new }
  let(:playerX){ Player.new({marker: "X"}) }
  let(:playerO){ Player.new({marker: "O"}) }

  context "#choice" do
    context "winning" do
      before {
        game.board.update_board("X", 0)
        game.board.update_board("X", 3)
        game.board.update_board("O", 4)
        game.board.update_board("O", 7)

        game.set_mode("1")
        game.active_player.marker = "X"
        game.opponent.marker = "O"
      }
      it "should return the winning move" do
        expect(Minmax.choice(game)).to eq 6
        game.switch_active_player
        expect(Minmax.choice(game)).to eq 1
      end
    end
    context "blocking" do
      before {
        game.board.update_board("X", 0)
        game.board.update_board("O", 1)
        game.board.update_board("O", 4)

        game.set_mode("1")
        game.active_player.marker = "X"
        game.opponent.marker = "O"
      }
      it "should return the blocking move" do
        expect(Minmax.choice(game)).to eq 7
      end
    end
  end

  context "#score" do
    before{
      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("X", 2)
      game.board.update_board("O", 4)
      game.board.update_board("O", 5)
      game.board.update_board("O", 6)

      game.set_mode("1")
      game.active_player.marker = "X"
      game.opponent.marker = "O"
      Minmax.game = game
    }
    it "should return 10 if board is won by active_player" do
      expect(Minmax.score(game.board, 0)).to eq 10
      expect(Minmax.score(game.board, 1)).to eq 9
      expect(Minmax.score(game.board, 9)).to eq 1
    end
    it "should return -10 if board is won by opponent" do
      game.switch_active_player
      expect(Minmax.score(game.board, 0)).to eq -10
      expect(Minmax.score(game.board, 1)).to eq -9
      expect(Minmax.score(game.board, 9)).to eq -1
    end
    it "should return 0 if board is not won" do
      game.board.update_board(2, 2)
      expect(Minmax.score(game.board, 0)).to eq 0
    end
  end

  context "#board_copy" do
    it "should return a cloned board" do
      expect(Minmax.board_copy(game.board)).to_not eq game.board
    end
  end

  context "#next_player" do
    it "should return the next player" do
      game.set_mode("1")
      game.active_player.marker = "X"
      playerX = game.active_player
      game.opponent.marker = "O"
      playerO = game.opponent
      Minmax.game = game
      expect(Minmax.next_player(playerX)).to eq playerO
      expect(Minmax.next_player(playerO)).to eq playerX
    end
  end
end