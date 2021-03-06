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

  def pretty_hand
    cards.collect {|card| card.original_value}
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
