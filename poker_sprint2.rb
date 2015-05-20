class Player

  attr_accessor :name
  def initialize(name)
    @name = name
  end

end

class Deal
  require 'pry'
  require 'active_support'

  def self.cards
    File.open("./poker.txt", "r") do |f|
      f.each_line do |line|
        game = Game.new(objectify(line))
        game.winner
      end
    end
    binding.pry

    puts Game.games_count
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

class Game
  @@games_count = 0
  @@player_wins_count = Hash.new(0)

  attr_reader :hands
  def initialize(hands)
    @hands = hands
    @@games_count += 1
    hands.each do |hand|
      @@player_wins_count[hand.player.name]
    end
  end

  def self.add_win_to_player(player)
    @@player_wins_count[player] += 1
  end

  def self.get_player_winnings_count
    @@player_wins_count
  end

  def self.games_count
    @@games_count
  end

  def rankings
    hands.sort
  end

  def compare_cards(player1, player2)
    if player1 == player2
      Game.add_win_to_player('draw')
      return
    end

    ziped_cards = player1.zip(player2)
    ziped_cards.each do |a, b|
      if (a.value ==  b.value)
        next
      elsif (a.value < b.value)
        Game.add_win_to_player(b.hand.player.name)
        return
      else (a.value > b.value)
        Game.add_win_to_player(a.hand.player.name)
        return
      end
    end

  end

  def winner
    sorted_hands_by_rank_asc = hands.sort
    if sorted_hands_by_rank_asc[0].rank == sorted_hands_by_rank_asc[1].rank

      if [:one_pair, :two_pairs, :three_of_a_kind, :four_of_a_kind].include? Hand::RANK.key(sorted_hands_by_rank_asc[0].rank)
        player1 = sorted_hands_by_rank_asc[0].repeated_cards + sorted_hands_by_rank_asc[0].unique_cards.sort
        player2 =  sorted_hands_by_rank_asc[1].repeated_cards + sorted_hands_by_rank_asc[1].unique_cards.sort

      elsif [:high_card, :straight, :flush, :straight_flush, :royal_flush].include? Hand::RANK.key(sorted_hands_by_rank_asc[0].rank)
        player1 = sorted_hands_by_rank_asc[0].cards.sort
        player2 = sorted_hands_by_rank_asc[1].cards.sort
      else
        # FULL HOUSE 3 , 2
        #[:full_house].include? Hand::RANK.key(sorted_hands_by_rank_asc[0].rank)
        player1 = sorted_hands_by_rank_asc[0].arrange_by_of_kind_first
        player2 = sorted_hands_by_rank_asc[1].arrange_by_of_kind_first
      end
      compare_cards(player1, player2)

    elsif sorted_hands_by_rank_asc[0].rank > sorted_hands_by_rank_asc[1].rank
      Game.add_win_to_player(sorted_hands_by_rank_asc[0].player.name)
    else
      Game.add_win_to_player(sorted_hands_by_rank_asc[1].player.name)
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

  attr_accessor :cards, :player

  def <=> other
    self.rank <=> other.rank
  end

  def add_cards(cards)
    self.cards = cards
  end

  def add_player(player)
    self.player = player
  end

  def values
     values ||= cards.collect(&:value ).sort.reverse
  end

  def suits
    suits ||= cards.collect(&:suit)
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

  def one_pair?
    of_a_kind? && repeated_cards?(2)
  end

  def two_pairs?
    grouped_duplicates = cards.group_by(&:value).select { |k,v| v.size > 1}
    grouped_duplicates.length == 2
  end

  def three_of_a_kind?
    of_a_kind? && repeated_cards?(3) #(number_of_a_kind == 3)
  end

  def four_of_a_kind?
    of_a_kind? && repeated_cards?(4)
  end

  def of_a_kind?
    dups ||= cards.uniq { |card| card.value }.uniq != cards.length
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

  def straight_flush?
    straight? && flush?
  end

  def royal_flush?
    flush? && straight? && (low_card.value == 10)
  end

  def number_of_a_kind
    count ||= repeated_cards.length
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

  def repeated_cards
    counts = Hash.new(0)
    cards.each { |card| counts[card.value] += 1}
    repeated_values = counts.select { |v, count| count > 1 }
    repeated_cards = cards.select { |card| repeated_values.include?(card.value)}
  end


  def repeated_cards?(num_times)
    counts = Hash.new(0)
    cards.each { |card| counts[card.value] += 1}
    repeated_values = counts.select { |v, count| count == num_times }
    repeated_values.any?
  end

  def get_three_of_kind_cards
    counts = Hash.new(0)
    cards.each { |card| counts[card.value] += 1}
    repeated_values = counts.select { |v, count| count == 3 }
    repeated_cards = cards.select { |card| repeated_values.include?(card.value)}
  end

  def get_pairs_of_cards
    counts = Hash.new(0)
    cards.each { |card| counts[card.value] += 1}
    repeated_values = counts.select { |v, count| count == 2 }
    repeated_cards = cards.select { |card| repeated_values.include?(card.value)}
  end

  def arrange_by_of_kind_first
    self.get_three_of_kind_cards + self.get_pairs_of_cards
  end

  def compare_cards(hand1, hand2)
    hand1.cards.zip(hand2.cards)
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
  attr_accessor :hand

  def initialize(hash={})
    @suit = hash[:suit]
    @value = number_value(hash[:number])
  end

  def <=> other
    other.value <=> self.value
  end

  def add_hand(hand)
    self.hand = hand
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
