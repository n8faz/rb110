# What happens when we modify an array while we are iterating over it? What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# 1 and delete 1 and 2 [3, 4]
# 3 and delete 3, then length is same so return [3, 4]

# What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# 1 and delete 4 [1, 2, 3]
# 2 and delete 3 [1, 2]

# the iterations operate on the original array in real time, so any changes to the array in the iterations, affect the iterations going forward
