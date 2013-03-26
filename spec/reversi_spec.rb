require 'spec_helper'
require 'reversi'

describe Board do
  subject { Board.new }
  it "should have a 64 square board" do
    subject.rows.flatten.length.should == 64
  end

  it "should have four pieces" do
    subject.rows.flatten.compact.length.should == 4
  end

  it "should have correct color pieces in correct starting positions" do
    subject[3, 3].color.should == :blue
    subject[4, 4].color.should == :blue
    subject[3, 4].color.should == :red
    subject[4, 3].color.should == :red
  end

  it "should place a piece" do
    subject.place(:red, [5, 4])
    subject[5, 4].color.should == :red
  end

  describe "#valid_move?" do
    it "returns false when position occupied" do
      subject.valid_move?(:red, [3, 3]).should == false
    end

    it "returns false if position off the board" do
      subject.valid_move?(:red, [-1, -1]).should == false
      subject.valid_move?(:blue, [8, 8]).should == false
    end

    it "returns false if position does not have same color piece in line with opposite color between" do
      subject.valid_move?(:blue, [5, 5]).should == false
      subject.valid_move?(:red, [2, 5]).should == false
    end

    it "returns true if move possible within ruleset" do
      subject.valid_move?(:blue, [5, 3]).should == true
    end

  end
end