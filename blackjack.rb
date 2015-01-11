# Blackjack Assignment
# Tealeaf: C01L02
require 'pry'

class Deck
  attr_accessor :cards
  def initialize
    @cards = []
    %w(Hearts Diamonds Clubs Spades).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 Jack King Queen Ace).each do |card|
        @cards << Card.new(suit, card)
      end
    end
  end

  def shuffle_deck!
    cards.shuffle!
  end

  def deal_a_card
    cards.pop
  end

  def count_remaining_cards
    cards.count
  end
end

class Card
  attr_accessor :suit, :value
  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def to_s
    "The #{value} of #{suit}"
  end
end

module Hand
  def show_hand
    puts "#{name}'s hand"
    cards.each { |card| puts "=> #{card}" }
    puts "=> #{hand_total}"
  end

  def hand_total
    values = cards.map{ |card| card.value }

    total = 0
    values.each do |value|
      if value == 'Ace'
        total += 11
      else
        total += (value.to_i == 0 ? 10 : value.to_i)
      end
    end

    # Correct for Aces
    values.select{ |value| value == 'Ace'}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end
end

class Dealer
  include Hand
  attr_accessor :name, :cards
  def initialize
    @name = 'Dealer'
    @cards = []
  end
end

class Player
  include Hand
  attr_accessor :name, :cards
  def initialize(name)
    @name = name
    @cards = []
  end
end

deck = Deck.new
deck.shuffle_deck!
player = Player.new('Rick')
player.cards << deck.deal_a_card
player.cards << deck.deal_a_card
player.show_hand
dealer = Dealer.new
dealer.cards << deck.deal_a_card
dealer.cards << deck.deal_a_card
dealer.show_hand

class Game
  def initialize
  end
# A dealer shuffles two decks of cards
# A dealer deals one card face down to player
# A dealer deals one card face down to self
# A dealer deals one card face up to player
# A dealer deals one card face up to self
#
# Player flips card
# If player does not hit blackjack
# Player can hit or stay
# Player will either hit blackjack, bust or can hit or stay
# If player busts then dealer wins
#
# Dealer flips card
# If dealer does not hit blackjack
# If dealer is less than 17 dealer must hit
# If dealer is 17 or higher dealer must stay
#
# Compare score and determine winner
end
