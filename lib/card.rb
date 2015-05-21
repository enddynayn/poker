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

  def original_value
    value = FACE_CARDS.key(self.value) || self.value
    "#{value}#{self.suit}"
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
