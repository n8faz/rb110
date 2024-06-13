require "pry"

def deal_card(deck)
  suit = deck.keys.sample
  value = deck[suit].sample
  deck[suit].delete(value)
  [suit, value]
end

def calculate_value(cards)
  values = cards.map { |card| card[1]}

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end

  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(total)
  total > 21
end

def dealer_stay?(total)
  total >= 17
end

deck = {
        H: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        D: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        C: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        S: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
        }



dealer_cards = [deal_card(deck), deal_card(deck)]
player_cards = [deal_card(deck), deal_card(deck)]


player_value = calculate_value(player_cards)

puts "Dealer's upcard is: #{dealer_cards[0][1]}"
puts "You have: #{player_cards[0][1]} and #{player_cards[1][1]}"
puts "Your value is: #{player_value}"

answer = nil
loop do
  puts "hit or stay?"
  answer = gets.chomp
  break if answer == "stay" || busted?(player_value)
  player_cards << deal_card(deck) if answer == "hit"
  player_value = calculate_value(player_cards)
  puts "You now have " + player_cards.map { |card| card[1]}.join(', ').insert(-2, "and ")
  puts "Your value is: #{player_value}"
  if busted?(player_value)
    puts "You busted. Dealer wins."
    break
  end
end

unless busted?(player_value)
  puts "The dealers facedown card was #{dealer_cards[1][1]}"
  puts "The dealer has: #{dealer_cards[0][1]} and #{dealer_cards[1][1]}"
  loop do
    dealer_value = calculate_value(dealer_cards)

    puts "The dealer's value is #{calculate_value(dealer_cards)}"
    if busted?(dealer_value)
      puts "Dealer bust. You win!"
      break
    elsif dealer_stay?(dealer_value)
      puts "Dealer stays. Their value is #{calculate_value(dealer_cards)}"
      break
    else
      puts "The dealer has to take a card"
      sleep 2
      dealer_cards << deal_card(deck)
      puts "The dealer has " + dealer_cards.map { |card| card[1]}.join(', ').insert(-2, "and ")
    end
  end
end
#binding.pry
