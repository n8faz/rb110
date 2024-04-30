require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

def integer?(num)
  num.to_i.to_s == num
end

def positive_number?(num)
  num.to_i > 0
end

def valid_number?(num)
  integer?(num) && positive_number?(num)
end

def ready?
  prompt "Are you ready to begin?"
  answer = gets.chomp
  true if answer.downcase.start_with?('y')
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def game_over?(score, rounds_to_win)
  score[:player] == rounds_to_win || score[:computer] == rounds_to_win
end

def yes_or_no?(answer)
  if answer.downcase.start_with?('y')
    'yes'
  elsif answer.downcase.start_with?('n')
    'no'
  end
end

def who_goes_first?(players)
  initial_player = nil
  loop do
    prompt "Do you care who goes first?"
    answer = gets.chomp
    answer = yes_or_no?(answer)
    if answer == 'no'
      prompt "Computer will choose who goes first"
      initial_player = players.sample
      break
    elsif answer == 'yes'
      initial_player = get_player_choice(initial_player)
      break
    else
      prompt "Invalid Choice. Please specify Yes or No"
    end
    break if initial_player
  end
  initial_player
end

def play_again?
  prompt "Play again? (y or n)"
  answer = gets.chomp
  true if answer.downcase.start_with?('y')
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(squares, punctuation = ", ", conjunction = "or")
  if squares.length == 1
    "#{squares[0]} is the only open square"
  else
    squares.join(punctuation).insert(-2, "#{conjunction} ")
  end
end

def find_immediate_threat(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  end
end

def alternate_player(current_player)
  if current_player == "Player"
    "Computer"
  elsif current_player == "Computer"
    "Player"
  end
end

def place_piece!(board, current_player)
  if current_player == "Player"
    player_places_piece!(board)
  elsif current_player == "Computer"
    computer_places_piece!(board)
  end
end

def computer_places_piece!(brd)
  square = nil

  WINNING_LINES.each do |line|
    square = find_immediate_threat(line, brd, COMPUTER_MARKER)
    break if square
  end

  if !square
    WINNING_LINES.each do |line|
      square = find_immediate_threat(line, brd, PLAYER_MARKER)
      break if square
    end
  end

  square = 5 if brd[5] == INITIAL_MARKER && !square
  square = empty_squares(brd).sample if !square
  brd[square] = COMPUTER_MARKER
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square: #{joinor(empty_squares(brd))} "
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end
  brd[square] = PLAYER_MARKER
end

def get_player_choice(initial_player)
  loop do
    prompt "Who should go first? (1 for Player, 2 for Computer)"
    first_player = gets.chomp
    if first_player == '1'
      initial_player = "Player"
      break
    elsif first_player == '2'
      initial_player = "Computer"
      break
    else
      prompt "Invalid Choice. Please enter 1 or 2"
    end
  end
  initial_player
end

def get_answer
  loop do
    answer = gets.chomp
    answer = yes_or_no?(answer)
    break if answer == 'no' || 'yes'
    prompt "Invalid Choice. Please specify Yes or No"
end

def get_name
  name = nil
  loop do
    name = gets.chomp
    if name.empty? || name.start_with?(' ')
      prompt "Sorry, I didn't get that. What is your name?"
    else
      break
    end
  end
  name
end

def get_rounds_to_win
  rounds_to_win = 0
  loop do
    rounds_to_win = gets.chomp
    break if valid_number?(rounds_to_win)
      prompt "That isn't a valid number. Please enter the number of rounds to win. (Example: 3 or 5)"
    end
  end
  rounds_to_win
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def keep_score(brd, score)
  winner = detect_winner(brd)
  if winner == 'Player'
    score[:player] += 1
  elsif winner == 'Computer'
    score[:computer] += 1
  end
  score
end

def print_intro
  system 'clear'
  prompt "Welcome to Tic-Tac-Toe!"
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt "First to win 5 rounds is the winner."
end

def print_winner(score, rounds_to_win)
  if score[:player] == rounds_to_win
    prompt "Player is the winner!"
  elsif score[:computer] == rounds_to_win
    prompt "Computer is the winner!"
  end
end

def print_score(score, rounds_to_win)
  if game_over?(score, rounds_to_win)
    prompt "Final Score: "
  else
    prompt "Current Score:"
  end
  prompt "Player: #{score[:player]} "
  prompt "Computer: #{score[:computer]} "
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, score)
  print_intro
  print_score(score)
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def setup_game()
  prompt "Welcome to Tic-Tac-Toe! Let's start by getting your name"
  name = get_name
  prompt "Hello, #{name}! I have a few questions to ask before we start"
  prompt "How many rounds must be won for a winner to be declared?"
  rounds_to_win = get_rounds_to_win
  prompt "Great, first to win #{rounds_to_win} rounds is the winner."
  prompt "Last Question. Do you care who goes first?"
  answer = get_answer
  if answer == 'no'
    prompt "Computer will choose who goes first"
    initial_player = players.sample
  elsif answer == 'yes'
    initial_player = get_player_choice
  end
  prompt "#{initial_player} will make the first move"
  prompt "Let's begin! Loading the board..."
  sleep 3
end

def play_turn(score, players, board, current_player)
  loop do
    display_board(board, score)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end
end

def play_round(score, players)
  loop do
    board = initialize_board
    current_player = initial_player
    prompt "#{current_player} will make the first move"
    prompt "Let's begin! Loading the board..."
    sleep 3
    display_board(board, score)

    play_turn(score, board, current_player)

    display_board(board, score)
    if someone_won?(board)
      prompt "#{detect_winner(board)} won this round!"
      score = keep_score(board, score)
    else
      prompt "It's a tie!"
    end

    print_score(score)
    break if game_over?(score)
    prompt "Continue to next round?"
    answer = gets.chomp
    break unless answer.downcase.start_with?('y')
  end
end


# Program start
name = ''
rounds_to_win = 0
current_player = nil
players = ["#{name}", "Computer"]
score = { player: 0, computer: 0 }
loop do
  print_intro
  play_round(score, players) if ready?
  print_winner(score)

  break unless play_again?
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
