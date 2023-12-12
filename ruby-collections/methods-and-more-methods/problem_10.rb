# What is the return value of the following code? Why?

[1, 2, 3].map do |num|
  if num > 1
    puts num
  else
    num
  end
end

# The return value is [1, nil, nil]. This is because in the first iteration, 1 is returned because it does not meet the if condition. The next two elements do meet the if condition, so puts method is invoked, which returns nil and is what map adds to its collection.
