require 'pry'
class Dealer


end

class Hand

  def initialize
    @hand = ['8C', 'TS', 'KC', '9H', '4S']
    or
    @hand = [{value: 8, suit: 'C'}, {value: 10, suit: 'S'}, {value: 14, suit: 'C'} {value: 13, suit: 'H'}, {value: 4, suit: 'S'} ]

    # @hand = [Card.new, Card.new, Card.new, .....]
  end


  def order
  end

  def high_card
  end

  def one_pair?
  end

  def two_pairs?
  end

  def three_of_a_kind?
  end

  def straight?
  end

  def flush?
  end

  def straight_flush?
  end

  def royal_flush?
  end

  def pairs?
  end


end

# class Card
    # T = 10
#     J = 11
#     Q = 12
#      K = 13
#       A = 14
#   attr_reader :value, :suit
#   def initialize
#     @card =
#   end

#   def suit
#   end

#   def value
#   end

    # def real_value
    # end

# end


# game = Game.new
# puts game.game

# T = 10
# J = 11
# Q = 12
# K = 13
# A = 14

# 1. start with the hand and it methods
