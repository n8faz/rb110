require "pry"
require "yaml"

MESSAGES = YAML.load_file('twenty_one_messages.yml')
SCORE = 21
DEALER_STAY_AT = 17
POINTS_TO_WIN = 5

def clear_screen
  system "clear"
end

def prompt(msg)
  puts "=> #{msg}"
end

def answer
  answer = nil
  loop do
    answer = gets.chomp
    answer = yes_or_no?(answer)
    break if answer == 'no' || answer == 'yes'
    prompt MESSAGES['invalid_choice']
  end
  answer
end

def yes_or_no?(answer)
  if answer.downcase.start_with?('y')
    'yes'
  elsif answer.downcase.start_with?('n')
    'no'
  end
end

def play?
  prompt MESSAGES['play?']
  answer = answer()
  answer
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
    sum -= 10 if sum > 21
  end

  sum
end

def compare_values(player, dealer)
  if player > dealer
    'player'
  elsif dealer > player
    'dealer'
  elsif player == dealer
    'push'
  end
end

def detect_result(player_value, dealer_value)
  if player_value > 21
    :player_busted
  elsif dealer_value > 21
    :dealer_busted
  elsif dealer_value < player_value
    :player
  elsif dealer_value > player_value
    :dealer
  else
    :push
  end
end

def print_result(player, dealer)
  result = detect_result(player, dealer)

  case result
  when :dealer_busted
    prompt MESSAGES['dealer_bust']
  when :player_busted
    prompt MESSAGES['player_bust']
  when :player
    prompt MESSAGES['player_win']
  when :dealer
    prompt MESSAGES['dealer_win']
  when :push
    prompt MESSAGES['push']
  end
end

def busted?(total)
  total > 21
end

def dealer_stay?(total)
  total >= 17
end

def hit_or_stay?
  answer = nil
  loop do
    prompt MESSAGES['hit_or_stay?']
    answer = gets.chomp.downcase
    if answer.start_with?('s')
      answer = 'stay'
      break
    elsif answer.start_with?('h')
      answer = 'hit'
      break
    else
      prompt MESSAGES['invalid_hit_or_stay']
    end
  end
  answer
end

def player_turn(deck, player_cards, player_value)
  loop do
    player_move = hit_or_stay?
    if player_move == "stay"
      prompt "You stay. Your value is: #{player_value}"
      break
    end
    player_cards << deal_card(deck) if player_move == "hit"
    player_value = calculate_value(player_cards)
    prompt "You hit. You now have #{player_cards.map { |card| card[1] }.join(', ')}"
    prompt "Your value is: #{player_value}"
    break if busted?(player_value)
  end
end

def dealer_turn(deck, dealer_cards, dealer_value)
  prompt "The dealer's facedown card was #{dealer_cards[1][1]}"
  loop do
    prompt "The dealer has #{dealer_cards.map { |card| card[1] }.join(', ')}"
    dealer_value = calculate_value(dealer_cards)
    prompt "The dealer's value is #{dealer_value}"
    break if busted?(dealer_value)
    if dealer_stay?(dealer_value)
      prompt "Dealer stays. Their value is #{calculate_value(dealer_cards)}"
      break
    else
      prompt "The dealer has to take a card..."
      dealer_cards << deal_card(deck)
    end
  end
end

def play_again?
  prompt "Play again?"
  answer = answer()
  true if answer == 'yes'
end

def keep_score(player, dealer, score)
  result = detect_result(player, dealer)

  case result
  when :dealer_busted
    score[:player] += 1
  when :player_busted
    score[:dealer] += 1
  when :player
    score[:player] += 1
  when :dealer
    score[:dealer] += 1
  end

  score
end


def print_score(score)
  game_over?(score)? (prompt MESSAGES['final_score']) : (prompt MESSAGES['current_score'])
  prompt "You: #{score[:player]}"
  prompt "Dealer: #{score[:dealer]}"
end

def game_over?(score)
  score[:player] == POINTS_TO_WIN || score[:dealer] == POINTS_TO_WIN
end

def next_round?
  answer = nil
  prompt MESSAGES['next_round?']
  answer = answer()
  answer
end

# Program Start

loop do
  clear_screen

  prompt "Let's play 21!"
  prompt MESSAGES['points'] + "#{POINTS_TO_WIN} is the winner!"
  play = play?

  puts
  if play == 'yes'
    score = {player: 0, dealer: 0}

    loop do
      clear_screen

      print_score(score)

      deck = {
        H: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        D: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        C: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'],
        S: ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
      }

      dealer_cards = [deal_card(deck), deal_card(deck)]
      player_cards = [deal_card(deck), deal_card(deck)]

      dealer_value = calculate_value(dealer_cards)
      player_value = calculate_value(player_cards)

      puts
      prompt "Dealer's upcard is: #{dealer_cards[0][1]}"
      prompt "You have: #{player_cards[0][1]} and #{player_cards[1][1]}"
      prompt "Your value is: #{player_value}"

      player_turn(deck, player_cards, player_value)
      player_value = calculate_value(player_cards)
      puts
      dealer_turn(deck, dealer_cards, dealer_value) unless busted?(player_value)

      dealer_value = calculate_value(dealer_cards)
      player_value = calculate_value(player_cards)

      unless busted?(player_value) || busted?(dealer_value)
        puts
        prompt "You have #{player_cards.map { |card| card[1] }.join(', ')}"
        prompt "Your value is: #{player_value}"
        prompt "Dealer has #{dealer_cards.map { |card| card[1] }.join(', ')}"
        prompt "Dealer's value is: #{dealer_value}"
        puts
      end

      print_result(player_value, dealer_value)
      puts
      score = keep_score(player_value, dealer_value, score)
      print_score(score)

      break if game_over?(score) || next_round? == 'no'
    end
  end

  break unless play_again?
end

prompt "Thanks for playing! Goodbye!"
