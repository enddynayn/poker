require 'hand'
require 'card'

RSpec.describe Hand do
  describe "Hand Rankings" do
    it "should return '0' rank for high card" do
      hand = "8C TS KC 9H 4S"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(0)
    end

    it "should rank '1' for pairs" do
      hand = "8C 8S KC 9H 4S"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(1)
    end

    it "should rank '2' for two pairs" do
      hand = "8C 8S KC KH 4S"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(2)
    end

    it "should rank '3' for three of a kind" do
      hand = "8C 8S 8C KH 4S"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(3)
    end

    it "should rank '4' for straigth" do
      hand = "2C 3S 4C 5H 6S"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(4)
    end

    it "should rank '5' for flush" do
      hand = "2C 9C 4C 5C 6C"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(5)
    end

    it "should rank '6' for full house" do
      hand = "2C 2C 2C 5C 5C"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(6)
    end

    it "should rank '7' for for four of a kind" do
      hand = "2C 2C 2C 2C 5C"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(7)
    end

    it "should return '8' rank for straight flush" do
      hand = "2C 3C 4C 5C 6C"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(8)
    end

    it "should return '9' rank for roayl flush" do
      hand = "TC JC QC KC AC"
      new_hand = create(hand)
      expect(new_hand.rank).to eql(9)
    end
  end
end
