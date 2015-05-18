class Player

  attr_accessor :name
  def initialize(name)
    @name = name
  end

end

class Deal
  require 'pry'
  require 'json'
  require 'active_support'

  def self.cards
    File.open("./poker.txt", "r") do |f|
      f.each_line do |line|
        begin
          game = Game.new(objectify(line))
          game.winner
        rescue
          puts 'oooh nooo!'
          binding.pry
        end
      end
    end
  end

  def self.objectify(line)
    # relationships
    # player = Player.new
    # hand = Hand.new
    # hand.add_player(player)
    # card = Card.new(....)
    # card.add_hand(hand)

    cards = line.gsub(/\s+/m, ' ').strip.split(" ")
    cards.collect! do |card|
      suit = card.match(/[chds]/i).to_s
      number = card.match(/[^chds]/i).to_s
      Card.new(suit: suit, number: number)
    end
    # binding.pry
    hands = cards.each_slice(5).to_a
    binding.pry
    hands.map!.each_with_index {|hand, index| Hand.new(hand, Player.new("player#{index}".to_sym))}
  end

end

class Game
  attr_reader :hands
  def initialize(hands)
    @hands = hands
  end

  def rankings
    hands.sort
  end

  def winner

    sorted_hands_by_rank_asc = hands.sort
    if sorted_hands_by_rank_asc[0].rank == sorted_hands_by_rank_asc[1].rank
        if sorted_hands_by_rank_asc[0].rank == 0
          player1 = sorted_hands_by_rank_asc[0].cards.sort
          player2 = sorted_hands_by_rank_asc[1].cards.sort
          ziped_card = player1.zip(player2)
          winner = []
          ziped_card.each do |a, b|
            if (a.value >  b.value)
              winner.push(a)
            elsif (a.value <=> b.value)
              winner.push(b)
            else
              0
            end
          end
        end
        binding.pry

       # return if c
       # ombined_cards.sort {|a,b| a.value <=> b.value }.reverse.group_by(&:value).select { |v, card| card.length == 1}.first.present?
       # puts 'draw'
      # if sorted_hands_by_rank_asc[0].rank == 1
      #   if pairs.value == pair.values
      #     highest_card = remove_all_pairs
      #     highest_cart.player
      #     add_win_to(player)
      # => a -b draw
      #   end

      #    if sorted_hands_by_rank_asc[0].rank == 2
      #       tricky
      # => a - b draw
      #    end

      #    if sorted_hands_by_rank_asc[0].rank == 3
      #     check_to_see_who has the highest 3 of a kind
      #
      #    end

      #    if sorted_hands_by_rank_asc[0].rank == 4
      #     draw
      #    end

      #    if a - b.present?
            # draw
      #    else
      #     get the max card
      #    end
            #    if sorted_hands_by_rank_asc[0].rank == 5
            # a-b get highest card
      #     draw

            #    if sorted_hands_by_rank_asc[0].rank == 6
            # get highest card
      #
      #    end

      #    if sorted_hands_by_rank_asc[0].rank == 7
            # sort
            # pop last card
            #get highest card
      #    end
        puts '333333333333333333333333333333' * 1000 if sorted_hands_by_rank_asc[0].rank == 3
        puts '222222222222222222222222' * 10 if sorted_hands_by_rank_asc[0].rank == 2
        puts '444444 333333 straight straight  444444' if sorted_hands_by_rank_asc[0].rank == 4
        puts '666666666666666666666666' if sorted_hands_by_rank_asc[0].rank == 6
        puts '77777777777777777777' if sorted_hands_by_rank_asc[0].rank == 7
        puts '8888888888888888888' if sorted_hands_by_rank_asc[0].rank == 8
        puts '9999999999999999999' if sorted_hands_by_rank_asc[0].rank == 9
        puts "ranking: #{sorted_hands_by_rank_asc[0].rank}"
      # puts '*********************** hand 1 ***********************'
      # puts "ranking: #{sorted_hands_by_rank_asc[0].rank}"
      # puts sorted_hands_by_rank_asc[0].values
      # puts sorted_hands_by_rank_asc[0].suits
      # puts '***********************'
      # puts '*********************** hand 2 ***********************'
      # puts "ranking: #{sorted_hands_by_rank_asc[1].rank}"
      # puts sorted_hands_by_rank_asc[1].values
      # puts sorted_hands_by_rank_asc[1].suits
      # puts '***********************'
    #   if one_pair
    #     highest_pair(a,b)
    #   if two_pair
    #     get highest_pair
    #   if three_of_a_kind
    #     get highest kind
    #     if straight
    #       get_highest straight
      # binding.pry
      # puts 'same ranking both players have the same ranking'

    elsif sorted_hands_by_rank_asc[0].rank > sorted_hands_by_rank_asc[1].rank
      puts '' #'player 1 wins'
    else
      puts '' #'player 2 wins'
    end
  end
end

class Hand
  include Comparable

  HAND_VALUES_METHODS = [
     :royal_flush?, :straight_flush?, :four_of_a_kind?, :full_house?,
     :flush?, :straight?, :three_of_a_kind?, :two_pairs?, :one_pair?, :high_card
    ]

  RANK = {
    high_card: 0,
    one_pair: 1,
    two_pairs: 2,
    three_of_a_kind: 3,
    straight: 4,
    flush: 5,
    full_house: 6,
    four_of_a_kind: 7,
    straight_flush: 8,
    royal_flush: 9,
  }

  attr_reader :cards, :player

  def initialize(cards, player)
    @cards = cards
    @player = player
  end

  def <=> other
    self.rank <=> other.rank
  end

  def rank
    hand_value ||= HAND_VALUES_METHODS.each do |method|
      if method(method).call
        hand_value = method.to_s.sub(/[?]/, '').to_sym
        return RANK[hand_value]
      end
    end
  end

  def low_card
    cards.min_by do |card|
      card.value
    end
  end

  def high_card
    cards.max_by do |card|
      card.value
    end
  end

  def of_a_kind?
    dups ||= cards.uniq { |card| card.value }.uniq != cards.length
  end

  def number_of_a_kind
    count ||= 5 - cards.uniq { |card| card.value }.uniq.length
  end

  def type_of_a_kind
    if of_a_kind?
      case number_of_a_kind
      when 1
        :one_pair
      when 2
        :three_of_a_kind
      when 3
        :four_of_a_kind
      else
        raise 'You cannot have'
      end
    else
      false
    end
  end

  def one_pair?
    of_a_kind? && (number_of_a_kind == 1)
  end

  def two_pairs?
    of_a_kind? && (number_of_a_kind == 2)
  end

  def three_of_a_kind?
    of_a_kind? && (number_of_a_kind == 3)
  end

  def values
     values ||= cards.collect(&:value ).sort.reverse
  end

  def suits
    suits ||= cards.collect(&:suit)
  end

  def straight?
    start = values.sort[0]
    last_card = start + 4
    values.sort == [*start..last_card]
  end

  def flush?
    suits.uniq.length == 1
  end

  def full_house?
    two_pairs? && three_of_a_kind?
  end

  def four_of_a_kind?
    of_a_kind? && (number_of_a_kind == 4)
  end

  def straight_flush?
    straight? && flush?
  end

  # def repeats
  #   cards.group_by(&:value)
  # end

  def compare_hands
    # player1.cards.zip(player2.cards)
  end

  def royal_flush?
    flush? && straight? && (low_card.value == 10)
  end

  def repeated_cards
    counts = Hash.new(0)
    cards.each { |card| counts[card.value] += 1}
    repeated_values = counts.select { |v, count| count > 1 }
    repeated_cards = cards.select { |card| repeated_values.include?(card.value)}
  end

  def unique_cards
    cards - repeated_cards
  end

end

class Card
  include Comparable

  FACE_CARDS = {
    T: 10,
    J: 11,
    Q: 12,
    K: 13,
    A: 14,
  }

  attr_reader :value, :suit

  def initialize(hash={})
    @suit = hash[:suit]
    @value = number_value(hash[:number])
  end

  def <=> other
     other.value <=> self.value
  end

  def number_value(value)
    if is_num?(value)
      return Integer(value)
    else
      return FACE_CARDS[value.to_sym]
    end
  end

  private

  def is_num?(str)
    begin
      !!Integer(str)
    rescue ArgumentError, TypeError
      false
    end
  end
end

Deal.cards

