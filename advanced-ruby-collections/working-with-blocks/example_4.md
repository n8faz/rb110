```ruby
my_arr = [[18, 7], [3, 12]].each do |arr|
  arr.each do |num|
    if num > 5
      puts num
    end
  end
end
```

**What will be the output and what will be the value of ``my_arr``?**

- The output will be:

```ruby
18
7
12
```

​	This is because the puts method is being called on line 4, within the if statement ``num >5`` causing any number greater than 5 to be printed to the string, creating a new line after and returning ``nil``. 

The value of ``my_arr`` is ``[[18, 7], [3, 12]]``. With the ``Array#each`` method being called, the return value of that method is always the collection it was called upon, so when local variable ``my_arr`` is being initialized to reference the return value of the ``#each`` method call, it will be assigned to the array that the method is called upon. 