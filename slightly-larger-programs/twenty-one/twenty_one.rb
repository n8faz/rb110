require "pry"
require "yaml"

MESSAGES = YAML.load_file('twenty_one_messages.yml')

SYMBOLS = { H: "\u2665", D: "\u2666", C: "\u2663", S: "\u2660", X: 'X' }
CARD_SUITS = [:H, :D, :C, :S]
CARD_VALUES =
  ['A ', '2 ', '3 ', '4 ', '5 ', '6 ', '7 ', '8 ', '9 ', '10', 'J ', 'Q ', 'K ']

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
  [cards[0], [:X, 'X ']]
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
  size = cards.size
  suits = []
  values = []

  cards.each do |card|
    suits << SYMBOLS[card[0]]
    values << card[1]
  end

  puts MESSAGES['blank_space'] + ("┌───────┐     " * size)
  puts MESSAGES['blank_space'] + ("|%s     |     " * size % values)
  puts MESSAGES['blank_space'] + ("|       |     " * size)
  puts MESSAGES['blank_space'] + ("|   %s   |     " * size % suits)
  puts MESSAGES['blank_space'] + ("|       |     " * size)
  puts MESSAGES['blank_space'] + ("|     %s|     " * size % values)
  puts MESSAGES['blank_space'] + ("└───────┘     " * size)
end
# rubocop:enable Metrics/AbcSize

def display_dealer_info(hands, hide)
  puts MESSAGES['dealer_cards']
  puts
  display_dealer_hand(hands[:dealer][:cards], hands[:dealer][:value], hide)
  puts
end

def display_player_info(hands)
  puts MESSAGES['player_cards']
  puts
  display_card_art(hands[:player][:cards])
  puts
  prompt "Player Value: #{display_value(hands[:player][:cards])}"
  puts
end

def display_dealer_hand(dealer_cards, dealer_value, hide)
  if hide
    display_card_art(hide_card(dealer_cards))
    puts
    prompt "Dealer Value: #{dealer_card_value(dealer_cards[0][1])}"
  else
    display_card_art(dealer_cards)
    puts
    prompt "Dealer Value: #{dealer_value}"
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

def display_board(score, hands, hide)
  clear_screen
  puts
  display_score(score)
  display_dealer_info(hands, hide)
  display_player_info(hands)
  puts MESSAGES['line']
  puts
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

def display_value(cards)
  values = cards.map { |card| card[1] }
  sum = 0

  if values.include?('A ')
    values.each do |value|
      sum += if value == 'A '
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

def calculate_value(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += if value == "A "
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
  if value == "A "
    "1 (or 11)"
  elsif value.to_i == 0
    "10"
  else
    value
  end
end

def number_of_aces(values)
  values.select { |value| value == 'A ' }.count
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

def player_turn(deck, hands, score)
  loop do
    display_board(score, hands, true)
    player_move = hit_or_stay?
    if player_move == "stay"
      prompt MESSAGES['you_stay']
      break
    end
    player_hits(deck, hands) if player_move == "hit"
    hands[:player][:value] = calculate_value(hands[:player][:cards])
    break if busted?(hands[:player][:value])
  end
end

def dealer_turn(deck, hands, score)
  dealer_reveals
  loop do
    hands[:dealer][:value] = calculate_value(hands[:dealer][:cards])
    break if busted?(hands[:dealer][:value])
    display_board(score, hands, false)
    if dealer_stay?(hands[:dealer][:value])
      dealer_stays(hands)
      break
    else
      dealer_hits(deck, hands)
    end
  end
end

def player_hits(deck, hands)
  hands[:player][:cards] << deal_card(deck)
  prompt MESSAGES['dealing_card']
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

def dealer_hits(deck, hands)
  prompt MESSAGES['dealer_hits']
  sleep 3
  hands[:dealer][:cards] << deal_card(deck)
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

# Program Start

loop do
  clear_screen
  display_intro

  play = play?
  if play == 'yes'
    score = { player: 0, dealer: 0 }

    loop do
      clear_screen

      display_score(score)

      deck = initialize_deck
      hands = {
        dealer: { cards: [deal_card(deck), deal_card(deck)] },
        player: { cards: [deal_card(deck), deal_card(deck)] }
      }

      hands[:dealer][:value] = calculate_value(hands[:dealer][:cards])
      hands[:player][:value] = calculate_value(hands[:player][:cards])

      puts
      player_turn(deck, hands, score)

      hands[:player][:value] = calculate_value(hands[:player][:cards])
      puts

      dealer_turn(deck, hands, score) unless busted?(hands[:player][:value])

      hands[:dealer][:value] = calculate_value(hands[:dealer][:cards])
      hands[:player][:value] = calculate_value(hands[:player][:cards])

      display_board(score, hands, false)
      puts
      display_result(hands[:player][:value], hands[:dealer][:value])
      puts
      score = keep_score(hands, score)
      display_score(score)
      puts
      break if game_over?(score) || next_round? == 'no'
      prompt MESSAGES['shuffling']
      sleep 3
    end
  end

  break unless play_again?
end

prompt MESSAGES['thanks']
