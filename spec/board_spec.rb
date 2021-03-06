require 'spec_helper'

describe Board do
  let(:board){ Board.new }
  let(:values){ [0,1,2,3,4,5,6,7,8] }
  let(:playerX){ Player.new({marker: "X"}) }
  let(:playerO){ Player.new({marker: "O"}) }

  context "#initialize" do
    it "should be a Board" do
      expect(board).to be_a(Board)
    end
    it "board should be empty" do
      expect(board.values).to eq(values)
    end
    it "board.available_spaces should contain all spaces" do
      expect(board.available_spaces).to eq(values)
    end
  end

  context "#update_board" do
    before { board.update_board("X", 0) }
    it "should update the board" do
      expect(board.values[0]).to eq("X")
    end
    it "should remove the chosen space from available_spaces" do
      expect(board.available_spaces).to_not include(0)
    end
  end

  context "#won?" do
    context "winner" do
      before {
        board.update_board("X", 0)
        board.update_board("X", 1)
        board.update_board("X", 2)
        board.update_board("O", 4)
        board.update_board("O", 5)
        board.update_board("O", 6)
      }
      it "should return true if board is won (with no player arguement)" do
        expect(board.won?).to eq true
      end
      it "should return true if board is won (with player arguement)" do
        expect(board.won?(playerX)).to eq true
      end
      it "should return false if board is not won by given player" do
        expect(board.won?(playerO)).to eq false
      end
    end
    context "no winner" do
      before {
        board.update_board("X", 0)
        board.update_board("X", 1)
        board.update_board("O", 4)
        board.update_board("O", 5)
        board.update_board("O", 6)
      }
      it "should return false if board is not won (with no player arguement)" do
        expect(board.won?).to eq false
      end
      it "should return false if board is not won (with player arguement)" do
        expect(board.won?(playerX)).to eq false
        expect(board.won?(playerO)).to eq false
      end
    end
  end

  context "#tie?" do
    it "should return true if there is a tie" do
      board.update_board("X", 0)
      board.update_board("X", 1)
      board.update_board("O", 2)
      board.update_board("O", 3)
      board.update_board("O", 4)
      board.update_board("X", 5)
      board.update_board("X", 6)
      board.update_board("O", 7)
      board.update_board("O", 8)

      expect(board.tie?).to eq true
    end
    it "should return false if there is no tie" do
      board.update_board("X", 0)
      board.update_board("X", 1)
      board.update_board("X", 2)
      board.update_board("O", 3)
      board.update_board("O", 4)
      board.update_board("X", 5)
      board.update_board("X", 6)
      board.update_board("O", 7)
      board.update_board("O", 8)

      expect(board.tie?).to eq false
      board.update_board(2, 2)
      expect(board.tie?).to eq false
    end
  end
end