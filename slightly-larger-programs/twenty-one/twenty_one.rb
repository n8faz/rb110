require "pry"
require "yaml"

MESSAGES = YAML.load_file('twenty_one_messages.yml')

SYMBOLS = { H: "\u2665", D: "\u2666", C: "\u2663", S: "\u2660", X: 'X' }
CARD_SUITS = [:H, :D, :C, :S]
CARD_VALUES =
  ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

SCORE = 21
DEALER_STAY_AT = 17
POINTS_TO_WIN = 2

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
  prompt MESSAGES['play_again?']
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

def reach_score?(total)
  total == SCORE
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

def initialize_deck
  deck = {}
  CARD_SUITS.each do |suit|
    deck[suit] = []
    CARD_VALUES.each { |value| deck[suit] << value }
  end
  deck
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

def player_hit_score
  prompt "You hit #{SCORE}! Nice!"
  sleep 3
end

def dealer_reveals
  prompt MESSAGES['revealing']
  sleep 3
end

def dealer_stays(hands)
  prompt "#{MESSAGES['dealer_stays']} #{hands[:dealer][:value]}"
  sleep 3
end

def player_stays(hands)
  prompt "#{MESSAGES['you_stay']} #{hands[:player][:value]}"
  sleep 3
end

def dealer_hits(deck, hands)
  prompt MESSAGES['dealer_hits']
  sleep 3
  hands[:dealer][:cards] << deal_card(deck)
end

def player_hits(deck, hands)
  hands[:player][:cards] << deal_card(deck)
  prompt MESSAGES['dealing_card']
  sleep 3
end

def skip_aces(values, sum)
  values.each do |value|
    sum += if value == 'A'
             next
           elsif value.to_i == 0
             10
           else
             value.to_i
           end
  end
  sum
end

def number_of_aces(values)
  values.select { |value| value == 'A' }.count
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

  number_of_aces(values).times do
    sum -= 10 if sum > SCORE
  end

  sum
end

def dealer_card_value(value)
  if value == "A"
    "1 (or 11)"
  elsif value.to_i == 0
    "10"
  else
    value
  end
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

def keep_score(hands, score)
  result = detect_result(hands[:player][:value], hands[:dealer][:value])

  if result == :player || result == :dealer_busted
    score[:player] += 1
  elsif result == :dealer || result == :player_busted
    score[:dealer] += 1
  end

  score
end

def display_intro
  prompt "Let's play 21!"
  display_rules if read_rules? == 'yes'
  prompt MESSAGES['points'] + "#{POINTS_TO_WIN} points is the winner!"
  puts
end

def display_rules
  clear_screen
  puts MESSAGES['rules']
  gets.chomp
end

# rubocop:disable Metrics/AbcSize
def display_card_art(cards)
  suits = []
  values_top = []
  values_bottom = []

  cards.each do |card|
    suits << SYMBOLS[card[0]]
    values_top << (card[1].ljust(2))
    values_bottom << (card[1].rjust(2))
  end

  puts MESSAGES['blank_space'] + ("┌───────┐     " * cards.size)
  puts MESSAGES['blank_space'] + ("|%s     |     " * cards.size % values_top)
  puts MESSAGES['blank_space'] + ("|       |     " * cards.size)
  puts MESSAGES['blank_space'] + ("|   %s   |     " * cards.size % suits)
  puts MESSAGES['blank_space'] + ("|       |     " * cards.size)
  puts MESSAGES['blank_space'] + ("|     %s|     " * cards.size % values_bottom)
  puts MESSAGES['blank_space'] + ("└───────┘     " * cards.size)
end
# rubocop:enable Metrics/AbcSize

def display_dealer_info(hands, hide, stay)
  puts MESSAGES['dealer_cards']
  puts
  display_dealer_hand(hands[:dealer][:cards], hide, stay)
  puts
end

def display_player_info(hands, stay)
  puts MESSAGES['player_cards']
  puts
  display_card_art(hands[:player][:cards])
  puts
  if stay
    prompt "Player Value: #{calculate_value(hands[:player][:cards])}"
  else
    prompt "Player Value: #{display_value(hands[:player][:cards])}"
  end
  puts
end

def display_dealer_hand(dealer_cards, hide, stay)
  if hide
    display_card_art(hide_card(dealer_cards))
    puts
    prompt "Dealer Value: #{dealer_card_value(dealer_cards[0][1])}"
  elsif stay
    display_card_art(dealer_cards)
    puts
    prompt "Dealer Value: #{calculate_value(dealer_cards)}"
  else
    display_card_art(dealer_cards)
    puts
    prompt "Dealer Value: #{display_value(dealer_cards)}"
  end
end

def display_result(player, dealer)
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

def display_board(round, score, hands, hide, player_stay, dealer_stay)
  clear_screen
  display_round(round)
  puts
  display_score(score)
  puts
  display_dealer_info(hands, hide, dealer_stay)
  display_player_info(hands, player_stay)
  puts MESSAGES['line']
  puts
end

def display_round(round)
  puts "********************* ROUND #{round} ********************"
end

def display_score(score)
  if game_over?(score)
    prompt MESSAGES['final_score']
  else
    prompt MESSAGES['current_score']
  end
  prompt "You: #{score[:player]}"
  prompt "Dealer: #{score[:dealer]}"
end

def display_shuffling
  prompt MESSAGES['shuffling']
  sleep 3
end

def display_winner(score)
  if score[:player] == POINTS_TO_WIN
    prompt MESSAGES['player_winner']
    puts
  elsif score[:dealer] == POINTS_TO_WIN
    prompt MESSAGES['dealer_winner']
    puts
  end
end

def display_value(cards)
  values = cards.map { |card| card[1] }
  sum = 0

  if values.include?('A')
    sum = skip_aces(values, sum)

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

# rubocop:disable Metrics/AbcSize
def player_turn(deck, hands, round, score)
  loop do
    display_board(round, score, hands, true, false, false)
    if reach_score?(hands[:player][:value])
      player_hit_score
      break
    end
    player_move = hit_or_stay?
    if player_move == "stay"
      player_stays(hands)
      break
    end
    player_hits(deck, hands) if player_move == "hit"
    hands[:player][:value] = calculate_value(hands[:player][:cards])
    break if busted?(hands[:player][:value])
  end
end
# rubocop:enable Metrics/AbcSize

def dealer_turn(deck, hands, round, score)
  display_board(round, score, hands, true, true, false)
  dealer_reveals
  loop do
    hands[:dealer][:value] = calculate_value(hands[:dealer][:cards])
    break if busted?(hands[:dealer][:value])
    display_board(round, score, hands, false, true, false)
    if dealer_stay?(hands[:dealer][:value])
      dealer_stays(hands)
      break
    else
      dealer_hits(deck, hands)
    end
  end
end

def end_of_round(round, score, hands)
  display_board(round, score, hands, false, true, true)
  display_result(hands[:player][:value], hands[:dealer][:value])
  puts
  display_winner(score)
  display_score(score)
  puts
end

# Program Start

loop do
  clear_screen
  display_intro

  play = play?
  if play == 'yes'
    score = { player: 0, dealer: 0 }
    round = 0

    loop do
      round += 1
      deck = initialize_deck
      hands = {
        dealer: { cards: [deal_card(deck), deal_card(deck)] },
        player: { cards: [deal_card(deck), deal_card(deck)] }
      }
      hands[:dealer][:value] = calculate_value(hands[:dealer][:cards])
      hands[:player][:value] = calculate_value(hands[:player][:cards])

      player_turn(deck, hands, round, score)
      unless busted?(hands[:player][:value])
        dealer_turn(deck, hands, round, score)
      end
      score = keep_score(hands, score)
      end_of_round(round, score, hands)

      break if game_over?(score) || next_round? == 'no'
      display_shuffling
    end
  end

  break unless play_again?
end

prompt MESSAGES['thanks']
