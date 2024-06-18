require "pry"
require "yaml"

MESSAGES = YAML.load_file('twenty_one_messages.yml')
SCORE = 21
DEALER_STAY_AT = 17
POINTS_TO_WIN = 5
SYMBOLS = {H: "\u2665", D: "\u2666", C: "\u2663", S: "\u2660", X: 'X' }

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
  answer
end

def play_again?
  prompt "Play again?"
  answer = answer()
  true if answer == 'yes'
end

def game_over?(score)
  score[:player] == POINTS_TO_WIN || score[:dealer] == POINTS_TO_WIN
end

def next_round?
  prompt MESSAGES['next_round?']
  answer
end

def read_rules?
  prompt MESSAGES['read_rules?']
  answer
end

def busted?(total)
  total > SCORE
end

def dealer_stay?(total)
  total >= DEALER_STAY_AT
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

def deal_card(deck)
  suit = deck.keys.sample
  value = deck[suit].sample
  deck[suit].delete(value)
  [suit, value]
end

def hide_card(cards)
  [cards[0], [:X, 'X']]
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
  puts "   " + " %s            " * size % values
  puts "   " + "|       |     " * size
  puts "   " + "|   %s   |     " * size % suits
  puts "   " + "|       |     " * size
  puts "   " + "       %s      " * size % values
  puts "   " + "└───────┘     " * size
end

def display_all_cards(player_cards, dealer_cards, player_value, dealer_value, hide)
  puts MESSAGES['dealer_cards']
  puts
  display_dealer_hand(dealer_cards, dealer_value, hide)
  puts
  puts MESSAGES['player_cards']
  puts
  display_cards_one(player_cards)
  puts
  prompt "Player Value: #{display_value(player_cards)}"
  puts
end

def display_dealer_hand(dealer_cards, dealer_value, hide)
  if hide
    display_cards_one(hide_card(dealer_cards))
    puts
    prompt "Dealer Value: #{dealer_cards[0][1]}"
  else
    display_cards_one(dealer_cards)
    puts
    prompt "Dealer Value: #{dealer_value}"
  end
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

def number_of_aces(values)
  values.select { |value| value == 'A' }.count
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

    if (sum += 11) >= SCORE
      sum = calculate_value(cards)
    else
      sum = "#{(sum - 10)} (or #{sum})"
    end
  else
    sum = calculate_value(cards)
  end
  sum
end

def detect_result(player_value, dealer_value)
  if player_value > SCORE
    :player_busted
  elsif dealer_value > SCORE
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

def player_turn(deck, player_cards, dealer_cards, player_value, dealer_value, score)
  loop do
    display_board(score, player_cards, dealer_cards, player_value, dealer_value, true)
    puts
    player_move = hit_or_stay?
    if player_move == "stay"
      prompt "You stay. Your value is: #{player_value}"
      break
    end
    player_cards << deal_card(deck) if player_move == "hit"
    player_value = calculate_value(player_cards)
    prompt "Dealing card..."
    sleep 3
    break if busted?(player_value)
  end
end

def dealer_turn(deck, player_cards, dealer_cards, player_value, dealer_value, score)
  prompt "Revealing Dealer's Card..."
  sleep 3
  display_board(score, player_cards, dealer_cards, player_value, dealer_value, false)
  loop do
    dealer_value = calculate_value(dealer_cards)
    break if busted?(dealer_value)
    if dealer_stay?(dealer_value)
      prompt "Dealer stays. Their value is #{dealer_value}"
      sleep 3
      break
    else
      prompt "The dealer has to take a card..."
      sleep 3
      dealer_cards << deal_card(deck)
      display_board(score, player_cards, dealer_cards, player_value, dealer_value, false)
    end
  end
end

def keep_score(player, dealer, score)
  result = detect_result(player, dealer)

  if result == :player || result == :dealer_busted
    score[:player] += 1
  elsif result == :dealer || result == :player_busted
    score[:dealer] += 1
  end

  score
end

def display_board(score, player_cards, dealer_cards, player_value, dealer_value, hide)
  clear_screen
  print_score(score)
  display_all_cards(player_cards, dealer_cards, player_value, dealer_value, hide)
  puts MESSAGES['line']
end

def print_score(score)
  game_over?(score) ? (prompt MESSAGES['final_score']) : (prompt MESSAGES['current_score'])
  prompt "You: #{score[:player]}"
  prompt "Dealer: #{score[:dealer]}"
end

def display_rules
  clear_screen
  puts MESSAGES['rules']
  prompt "Press Enter to continue"
  gets.chomp
end

def print_intro
  prompt "Let's play 21!"
  display_rules if read_rules? == 'yes'
  prompt MESSAGES['points'] + "#{POINTS_TO_WIN} points is the winner!"
end

# Program Start

loop do
  clear_screen
  print_intro
  puts
  play = play?
  if play == 'yes'
    score = { player: 0, dealer: 0 }

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
      player_turn(deck, player_cards, dealer_cards, player_value, dealer_value, score)
      player_value = calculate_value(player_cards)
      puts
      dealer_turn(deck, player_cards, dealer_cards, player_value, dealer_value, score) unless busted?(player_value)

      dealer_value = calculate_value(dealer_cards)
      player_value = calculate_value(player_cards)

      display_board(score, player_cards, dealer_cards, player_value, dealer_value, false)
      puts
      print_result(player_value, dealer_value)
      puts
      score = keep_score(player_value, dealer_value, score)
      print_score(score)
      puts
      break if game_over?(score) || next_round? == 'no'
    end
  end

  break unless play_again?
end

prompt "Thanks for playing! Goodbye!"
