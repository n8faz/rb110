# What is the return value of reject in the following code? Why?

[1, 2, 3].reject do |num|
  puts num
end

# reject returns a new array for all values that evaluate to false for the block given. This will return [1,2,3], since the return value of puts num is nil, and none of the values are nil, so each element is returned. 
