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

  def get_card(from_deck)
    cards << from_deck.deal_a_card
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
  include Comparable
  attr_accessor :name, :cards
  def initialize(name)
    @name = name
    @cards = []
  end

  def <=>(dealer)
    if self.hand_total == dealer.hand_total
      0
    elsif (self.hand_total > dealer.hand_total) ||
          (dealer.hand_total > 21)
      1
    else
      -1
    end
  end
end

class Game
  attr_accessor :deck, :player, :dealer
  def initialize
    @deck = Deck.new
    @deck.shuffle_deck!
    @player = Player.new('Rick')
    @dealer = Dealer.new
    system 'clear'
  end

  def play
    deal_cards
    play_player_hand
    if player.hand_total > 21
      puts 'Bust! Dealer wins'
    else
      play_dealer_hand
      pick_winner
    end
    redeal if play_again?
  end

  def play_again?
    puts 'Would you like to play again?'
    true if gets.chomp.downcase == 'y'
  end

  def redeal
    @deck = Deck.new
    @deck.shuffle_deck!
    player.cards = []
    dealer.cards = []
    system 'clear'
    play
  end

  def pick_winner
    if player == dealer
      puts 'It is a push'
    elsif player > dealer
      puts "#{player.name} wins!"
    else
      puts "#{dealer.name} wins... Boo!"
    end
  end

  def play_dealer_hand
    dealer.show_hand
    while dealer.hand_total < 17
      hit(dealer)
    end
    puts 'Blackjack!' if blackjack?(dealer)
    puts 'Bust!' if bust?(dealer)
  end

  def play_player_hand
    player.show_hand
    hit_or_stay unless blackjack?(player)
    puts 'Blackjack!' if blackjack?(player)
  end

  def hit_or_stay
    begin
      puts 'Would you like to hit or stay? (h/s)'
      response = gets.chomp.downcase
      hit(player) if response == 'h'
      response = 's' if bust?(player) || blackjack?(player)
    end while response == 'h'
  end

  def bust?(a_player)
    a_player.hand_total > 21
  end

  def blackjack?(a_player)
    a_player.hand_total == 21
  end

  def hit(a_player)
    a_player.get_card(deck)
    a_player.show_hand
  end

  def deal_cards
    2.times do
      player.get_card(deck)
      dealer.get_card(deck)
    end
  end
end

Game.new.play
