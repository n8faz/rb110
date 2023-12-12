# What is the return value of the select method below? Why?

[1, 2, 3].select do |num|
  num > 5
  'hi'
end

# The return value will be [1, 2, 3]. Return value of 'hi' will always evaluate to true, so each element will be selected, returning a new array of all the elements in the original array.
