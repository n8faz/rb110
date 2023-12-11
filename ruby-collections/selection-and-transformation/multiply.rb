def multiply(numbers, multiplier) # non-mutating
  multiplied = []
  counter = 0

  loop do
    break if counter == numbers.size

    current_number = numbers[counter]
    multiplied << current_number * multiplier

    counter += 1
  end

  multiplied
end

my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 3)
