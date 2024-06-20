SYMBOLS = {H: "\u2665", D: "\u2666", C: "\u2663", S: "\u2660"}
SCORE = 21
CARD_SUITS =[:H, :D, :C, :S]
CARD_VALUES = ['A ', '2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 ', '10', 'J ', 'Q ', 'K ']

def blank_space
  "     "
end

def display_card(card)
  suit = SYMBOLS[card[0]]
  value = card[1]
  if value == '10'
    puts "┌────────┐     "
    puts "|#{value}      |      "
    puts "|        |     "
    puts "|   #{suit}    |     "
    puts "|        |     "
    puts "|      #{value}|       "
    puts "└────────┘     "
  else
    puts "┌────────┐     "
    puts "|#{value}       |     "
    puts "|        |     "
    puts "|   #{suit}    |     "
    puts "|        |     "
    puts "|       #{value}|       "
    puts "└────────┘     "
  end
end

def display_value(value, size)
  if value == '10'
    puts "|#{value}      |      " * size
  else
    puts "|#{value}       |     " * size
  end

end

def display_cards_one(cards)
  size = cards.size
  suits = []
  values = []

  cards.each do |card|
    suits << SYMBOLS[card[0]]
    values << card[1]
  end

  puts "   " + "┌───────┐     " * size
  puts "   " + "|%s     |     " * size % values
  puts "   " + "|       |     " * size
  puts "   " + "|   %s   |     " * size % suits
  puts "   " + "|       |     " * size
  puts "   " + "|     %s|     " * size % values
  puts "   " + "└───────┘     " * size
end

def display_cards_two(cards)
  size = cards.size
  suits = []
  values = []

  cards.each do |card|
    values << card[1]
    suits << SYMBOLS[card[0]]
  end

  puts "┌────────┐     " * size
  puts " %s             " * size % values
  puts "|        |     " * size
  puts "|   %s    |     " * size % suits
  puts "|        |     " * size
  puts "       %s       " * size % values
  puts "└────────┘     " * size
end


def deal_card(deck)
  suit = deck.keys.sample
  value = deck[suit].sample
  deck[suit].delete(value)
  [suit, value]
end

def calculate_value(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A"
             11
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > SCORE
  end

  sum
end

def display_value(cards)
  values = cards.map { |card| card[1] }
  sum = 0

  if values.include?('A')
    values.each do |value|
      sum += if value == 'A'
              next
             elsif value.to_i == 0
              10
             else
              value.to_i
             end
      end

    (number_of_aces(values) - 1).times { sum += 1 }

    if (sum + 11) >= SCORE
      sum = calculate_value(cards)
    else
      sum += 11
      sum = "#{(sum - 10)} (or #{sum})"
    end
  else
    sum = calculate_value(cards)
  end
  sum
end

def number_of_aces(values)
  values.select { |value| value == 'A' }.count
end

def initialize_deck
  deck = {}
  CARD_SUITS.each do |suit|
    deck[suit] = []
    CARD_VALUES.each { |value| deck[suit] << value }
  end
  deck
end

deck = initialize_deck


cards = [[:H, '10'], deal_card(deck), deal_card(deck)]

#card = deal_card(deck)
cards_with_ace = [[:D, 'A'], [:C, 'A'], [:H, 'A'], [:S, '9']]

#display_card(card)

display_cards_one(cards)

# display_cards_two(cards)

# display_cards_three(cards)

#puts display_value(cards_with_ace)
dealer_cards = [deal_card(deck), deal_card(deck)]
player_cards = [deal_card(deck), deal_card(deck)]

dealer_value = calculate_value(dealer_cards)
player_value = calculate_value(player_cards)

hands = { dealer: { cards: dealer_cards, value: dealer_value }, player: { cards: player_cards, value: player_value } }

#p hands.dig(:dealer, :cards)
