require 'pry'
module HandHelper
  def create(hand)
    hand = hand.split
    new_hand = Hand.new
    cards = []
    hand.each do |card|
      suit = card.match(/[chds]/i).to_s
      number = card.match(/[^chds]/i).to_s
      card = Card.new(suit: suit, number: number)
      cards.push(card)
    end
    new_hand.add_cards(cards)
    new_hand
  end
end
