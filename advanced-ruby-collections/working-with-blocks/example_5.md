```ruby
[[1, 2], [3, 4]].map do |arr|
  arr.map do |num|
    num * 2
  end
end
```

**What will the return value be in this example?**

The return value will be the transformed array returned by the ``#map`` method call. This will end up being ``[[2, 4], [6, 8]]`` 