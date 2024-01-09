```ruby
[[1, 2], [3, 4]].map do |arr|
  puts arr.first
  arr.first
end
```

**Map out a detailed breakdown for the above example. What will be returned and what will be the side effects?**

The ``Array#map`` method is being called on the array ``[[1, 2], [3, 4]]``. This array contains two nested arrays ``[1, 2]`` and ``[3, 4]``. These arrays are passed to the block and assigned to local variable ``arr``. On line 2, the ``Array#first`` method is being called on ``arr`` and returns the element at index ``0`` of each array. These elements are ``1`` for the first array and ``3`` for the second. These return values are passed to the method ``Kernel#puts`` which outputs the return value and creates a new line after. The result of line 2 will end up with 

```ruby
1
3
```

being printed to the screen. Then, on line 3, the same ``#first`` method is being called on ``arr``. This is the last line of the block and is what will be returned by the block. Because this block was passed to the ``map`` method, this results in the array the method is called on to be transformed with the return value of the last line in the block. The array will end up being ``[1,3]`` and is what is returned. 