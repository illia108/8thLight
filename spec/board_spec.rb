require 'spec_helper'

describe Board do
  let(:board){ Board.new }
  let(:values){ [0,1,2,3,4,5,6,7,8] }

  context "initialize" do
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
end