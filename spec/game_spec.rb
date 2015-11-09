require 'spec_helper'

describe Game do
  let(:game){ Game.new }
  let(:values){ [0,1,2,3,4,5,6,7,8] }
  let(:playerX){ Player.new({marker: "X"}) }
  let(:playerO){ Player.new({marker: "O"}) }

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

  context "#get_computer_move" do
    before {
      game.board.values = [
        "X", 1, 2,
        3, 4, 5,
        6, 7, 8
      ]
      game.board.available_spaces = [1, 2, 3, 4, 5, 6, 7, 8]
      game.active_player = playerX
      game.opponent = playerO
    }
    it "should return the center position if open" do
      expect(game.get_computer_move).to eq 4
      game.switch_active_player
      expect(game.get_computer_move).to eq 4
    end
    it "should call Minmax.choice if center is taken" do
      game.board.values[4] = "O"
      expect(Minmax).to receive(:choice).with(game)
      game.get_computer_move
    end
  end

  context "#make_move" do
    before {
      game.active_player = playerX
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
      game.board.available_spaces = [2]
      expect(game.valid_move?("1")).to be false
      expect(game.valid_move?("23")).to be false
      expect(game.valid_move?("three")).to be false
    end
  end

  context "#won?" do
    it "should return true if game is won" do
      game.board.values = [
        "X", "X", "X",
        3, "O", "O",
        "O", 7, 8
      ]
      expect(game.won?).to eq true
    end
    it "should return false if game is not won" do
      game.board.values = [
        "X", "X", 2,
        3, "O", "O",
        "O", 7, 8
      ]
      expect(game.won?).to eq false
    end
  end

  context "#tie?" do
    it "should return true if there is a tie" do
      game.board.values = [
        "X", "X", "O",
        "O", "O", "X",
        "X", "O", "O"
      ]
      game.board.available_spaces = []
      expect(game.tie?).to eq true
    end
    it "should return false if there is no tie" do
      game.board.values = [
        "X", "X", "X",
        "O", "O", "X",
        "X", "O", "O"
      ]
      game.board.available_spaces = []
      expect(game.tie?).to eq false
      game.board.values = [
        "X", "X", 2,
        "O", "O", "X",
        "X", "O", "O"
      ]
      game.board.available_spaces = [2]
      expect(game.tie?).to eq false
    end
  end

  context Minmax do

    context "#choice" do
      context "winning" do
        before {
          game.board.values = [
            "X", 1, 2,
            "X", "O", 5,
            6, "O", 8
          ]
          game.board.available_spaces = [1, 2, 5, 6, 8]
          game.active_player = playerX
          game.opponent = playerO
        }
        it "should return the winning move" do
          expect(Minmax.choice(game)).to eq 6
          game.switch_active_player
          expect(Minmax.choice(game)).to eq 1
        end
      end
      context "blocking" do
        before {
          game.board.values = [
            "X", "O", 2,
            3, "O", 5,
            6, 7, 8
          ]
          game.board.available_spaces = [2, 3, 5, 6, 7, 8]
          game.active_player = playerX
          game.opponent = playerO
        }
        it "should return the blocking move" do
          expect(Minmax.choice(game)).to eq 7
        end
      end
    end

    context "#score" do
      before{
        game.board.values = [
          "X", "X", "X",
          3, "O", "O",
          "O", 7, 8
        ]
        game.active_player = playerX
        game.opponent = playerO
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
        game.board.values[2] = 2
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
        game.active_player = playerX
        game.opponent = playerO
        Minmax.game = game
        expect(Minmax.next_player(playerX)).to eq playerO
        expect(Minmax.next_player(playerO)).to eq playerX
      end
    end
  end

end