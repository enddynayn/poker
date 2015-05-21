require_relative 'game'
require_relative 'player'
require_relative 'hand'
require_relative 'card'
class Deal
  require 'pry'
  require 'active_support'

  def self.cards
    File.open("./poker.txt", "r") do |f|

      f.each_line do |line|
        game = Game.new(objectify(line))
        # final_rankings = game. = []
        puts "****" * 10
        game.winner
        puts "****" * 10
      end
    end
    # binding.pry

    puts "********************\n"
    puts "Total number of wins by each player: #{Game.get_player_winnings_count}"
    puts "********************\n"
    puts "total games: #{Game.games_count}"
    puts "********************\n"
  end

  def self.objectify(line)
    cards_data = line.gsub(/\s+/m, ' ').strip.split(" ")
    hands_data = cards_data.each_slice(5).to_a

    hands_array_objects = []
    hands_data.each_with_index do |hand, index|
      new_player = Player.new("player#{index + 1}")
      new_hand = Hand.new
      new_hand.add_player(new_player)

      cards = []
      hand.each do |card|
        suit = card.match(/[chds]/i).to_s
        number = card.match(/[^chds]/i).to_s
        card = Card.new(suit: suit, number: number)
        card.add_hand(new_hand)
        cards.push(card)
      end
      new_hand.add_cards(cards)
      hands_array_objects.push(new_hand)
    end
    hands_array_objects
  end

end
