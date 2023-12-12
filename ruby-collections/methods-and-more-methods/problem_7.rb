# What is the block's return value in the following code? How is it determined? Also, what is the return value of any? in this code and what does it output?

[1, 2, 3].any? do |num|
  puts num
  num.odd?
end

# the return value is true, this is determined by the return value of the last expression in the given block. In this block, the last expression is the method invocation #odd? on the parameter num. This can only return true or false and in this case is returning true. The return value of any? is also true, as any? will return true if the block evaluates as true, which it does. any? also stops iterating after the first iterationevaluates as true. 
