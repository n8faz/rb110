# What is the return value of each_with_object in the following code? Why?

['ant', 'bear', 'cat'].each_with_object({}) do |value, hash|
  hash[value[0]] = value
end

# the return value will be a hash object containing the key value pairs: {"a"=>"ant", "b"=>"bear", "c"=>"cat"}, this is because the iteration of each is being placed into a new object, in this case the object is specified as a hash, with an empty hash being passed in as an argument to the method #each_with_object the key is equal to the character at the 0 index of the string in each element, and the value is equal to the string in each element.
