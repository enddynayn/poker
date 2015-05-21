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
        puts "winner: #{b.hand.player.name} hand: #{b.hand.pretty_hand}"
        puts "loser: #{a.hand.player.name} hand: #{a.hand.pretty_hand}"
        return
      else (a.value > b.value)
        Game.add_win_to_player(a.hand.player.name)
        puts "winner: #{a.hand.player.name} hand: #{a.hand.pretty_hand}"
        puts "loser: #{b.hand.player.name} hand: #{b.hand.pretty_hand}"
        return
      end
    end

  end

  # REFACTOR: rename method and return array of objects in order of first placel, second...
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
        # FULL HOUSE
        #[:full_house].include? Hand::RANK.key(sorted_hands_by_rank_asc[0].rank)
        player1 = sorted_hands_by_rank_asc[0].arrange_by_of_kind_first
        player2 = sorted_hands_by_rank_asc[1].arrange_by_of_kind_first
      end
      compare_cards(player1, player2)

    elsif sorted_hands_by_rank_asc[0].rank > sorted_hands_by_rank_asc[1].rank
      Game.add_win_to_player(sorted_hands_by_rank_asc[0].player.name)
      puts "winner: #{sorted_hands_by_rank_asc[0].player.name} hand: #{sorted_hands_by_rank_asc[0].pretty_hand}"
      puts "loser: #{sorted_hands_by_rank_asc[1].player.name} hand: #{sorted_hands_by_rank_asc[1].pretty_hand}"
    else
      Game.add_win_to_player(sorted_hands_by_rank_asc[1].player.name)
      puts "winner: #{sorted_hands_by_rank_asc[1].player.name} hand: #{sorted_hands_by_rank_asc[1].pretty_hand}"
      puts "loser: #{sorted_hands_by_rank_asc[0].player.name} hand: #{sorted_hands_by_rank_asc[0].pretty_hand}"
    end
  end
end
