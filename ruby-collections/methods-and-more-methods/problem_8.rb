# How does take work? Is it destructive? How can we find out?

arr = [1, 2, 3, 4, 5]
arr.take(2)

# #take takes the given number of elements from an array and returns them in a new array. In this case the given number is 2, so it will take the first 2 elements of the array and return them [1,2]. This is not a destructive method as it is returning a new array not modifying the original. WE can find this out by reading the documentation on the method
