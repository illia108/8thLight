require 'spec_helper'

describe View do
  let(:view){ View.new }

  context "initialize" do
    it "should be a View" do
      expect(view).to be_a(View)
    end
  end
end