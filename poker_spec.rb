require_relative 'poker_sprint2'
RSpec.describe Game do
  describe "#score" do
    it "returns 0 for an all gutter game" do

      game = Game.new
      # 20.times { game.roll(0) }
      # expect(game.score).to eq(0)
    end
  end
end

    # puts 'dups'
    # puts hands[0].of_a_kind?
    # puts 'number of a kind'
    # puts hands[0].number_of_a_kind
    # puts 'number of a kind'
    # puts 'dups'
    # hand = hands[0]
    # puts 'hi card'
    # puts hand.high_card.value
    # puts 'hi card'
    # puts 'values'
    # puts hand.values
    # puts 'values'
    # puts 'straight'
    # puts hand.straight?
    # puts 'straight'
    # puts 'inspect'

    # puts 'straight flush'
    # puts hand.straight_flush?
    # puts 'straight flush'

    # puts hand.inspect

    # puts 'flush'

    # puts 'royal_flush'
    # puts hand.royal_flush?
    # puts 'royal_flush'
    # puts 'rank'
    # puts hand.rank
    # puts 'rank'
    # binding.pry