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

def print_intro(score)
  prompt "You're a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  prompt "First to win 5 rounds is the winner."
  print_score(score)
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, score)
  system 'clear'
  print_intro(score)
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

def find_immediate_threat(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
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

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
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

def print_score(score)
  if game_over?(score)
    prompt "Final Score: "
  else
    prompt "Current Score:"
  end
  prompt "Player: #{score[:player]} "
  prompt "Computer: #{score[:computer]} "
end

def game_over?(score)
  score[:player] == 5 || score[:computer] == 5
end

def print_winner(score)
  if score[:player] == 5
    prompt "Player is the winner!"
  elsif score[:computer] == 5
    prompt "Computer is the winner!"
  end
end

def play_round(score)
  loop do
    board = initialize_board
    display_board(board, score)

    loop do
      display_board(board, score)
      player_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
      computer_places_piece!(board)
      break if someone_won?(board) || board_full?(board)
    end

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

score = { player: 0, computer: 0 }
loop do
  play_round(score)
  print_winner(score)

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe! Good bye!"
