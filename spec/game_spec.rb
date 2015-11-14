require 'spec_helper'

describe Game do
  let(:game){ Game.new }
  let(:values){ [0,1,2,3,4,5,6,7,8] }

  context "#initialize" do
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
  end

  context "#set_mode" do
    it "should create two human players: mode 1" do
      game.set_mode("1")
      expect(game.active_player.human?).to be true
      expect(game.opponent.human?).to be true
    end
    it "should create two computer players: mode 2" do
      game.set_mode("2")
      expect(game.active_player.human?).to be false
      expect(game.opponent.human?).to be false
    end
    it "should create one human and one computer player: mode 3" do
      game.set_mode("3")
      expect(game.active_player.human?).to be true
      expect(game.opponent.human?).to be false
    end
    it "should return true for valid inputs" do
      expect(game.set_mode("1")).to be true
      expect(game.set_mode("2")).to be true
      expect(game.set_mode("3")).to be true
    end
    it "should return false for invalid inputs" do
      expect(game.set_mode("K")).to be false
      expect(game.set_mode("23")).to be false
      expect(game.set_mode("three")).to be false
    end
  end

  context "#set_player_order" do
    before {game.set_mode("1")}
    it "should not switch players on input of 1" do
      expect{game.set_player_order("1")}.to_not change{game.active_player}
    end
    it "should switch players on input of 2" do
      expect{game.set_player_order("2")}.to change{game.active_player}
    end
    it "should return true for valid inputs" do
      expect(game.set_player_order("1")).to be true
      expect(game.set_player_order("2")).to be true
    end
    it "should return false for invalid inputs" do
      expect(game.set_player_order("K")).to be false
      expect(game.set_player_order("23")).to be false
      expect(game.set_player_order("three")).to be false
    end
  end

  context "#switch_active_player" do
    before {game.set_mode("1")}
    it "should switch players" do
      expect{game.switch_active_player}.to change{game.active_player}
    end
  end

  context "#make_move" do
    before {
      game.set_mode("1")
      game.active_player.marker = "X"
      game.make_move(0)
    }
    it "should update the board" do
      expect(game.board.values[0]).to eq("X")
    end
    it "should remove the chosen space from available_spaces" do
      expect(game.board.available_spaces).to_not include(0)
    end
  end

  context "#valid_move?" do
    it "should return true for valid inputs" do
      expect(game.valid_move?("1")).to be true
      expect(game.valid_move?("2")).to be true
    end
    it "should return false for invalid inputs" do
      game.board.update_board("X", 1)
      expect(game.valid_move?("1")).to be false
      expect(game.valid_move?("23")).to be false
      expect(game.valid_move?("three")).to be false
    end
  end

  context "#won?" do
    it "should return true if game is won" do
      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("X", 2)
      game.board.update_board("O", 4)
      game.board.update_board("O", 5)
      game.board.update_board("O", 6)

      expect(game.won?).to eq true
    end
    it "should return false if game is not won" do
      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("O", 4)
      game.board.update_board("O", 5)
      game.board.update_board("O", 6)

      expect(game.won?).to eq false
    end
  end

  context "#tie?" do
    it "should return true if there is a tie" do
      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("O", 2)
      game.board.update_board("O", 3)
      game.board.update_board("O", 4)
      game.board.update_board("X", 5)
      game.board.update_board("X", 6)
      game.board.update_board("O", 7)
      game.board.update_board("O", 8)

      expect(game.tie?).to eq true
    end
    it "should return false if there is no tie" do

      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("X", 2)
      game.board.update_board("O", 3)
      game.board.update_board("O", 4)
      game.board.update_board("X", 5)
      game.board.update_board("X", 6)
      game.board.update_board("O", 7)
      game.board.update_board("O", 8)

      expect(game.tie?).to eq false
      game.board.update_board("X", 0)
      game.board.update_board("X", 1)
      game.board.update_board("O", 3)
      game.board.update_board("O", 4)
      game.board.update_board("X", 5)
      game.board.update_board("X", 6)
      game.board.update_board("O", 7)
      game.board.update_board("O", 8)

      expect(game.tie?).to eq false
    end
  end

end