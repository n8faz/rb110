# What is the return value of the following statement? Why?

['ant', 'bear', 'caterpillar'].pop.size

# This is an example of chaining methods. #size is being called on the return value of #pop called on a given array. #pop is a destructive method that removes the last element of the given array, and returns that value. This will result in the return value of ['caterpillar'] . The size of this returned string is 11 which is what will be returned by the #size method invocation.

