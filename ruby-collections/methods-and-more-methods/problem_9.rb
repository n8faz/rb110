# What is the return value of map in the following code? Why?

{ a: 'ant', b: 'bear' }.map do |key, value|
  if value.size > 3
    value
  end
end

# The return value of map is [nil, 'bear']
# This is because map returns an array that contains the return values of the block called with it. In this case the condition for the first element is evaluated as false, thus nil is returned. Then 'bear' is returned because that is what is returned by the block.
