def select_fruit(produce_list)
  produce_keys = produce_list.keys
  fruits = {}
  counter = 0

  loop do

    break if counter == produce_keys.size

    current_item_key = produce_keys[counter]
    current_item_value = produce_list[current_item_key]

    if current_item_value == 'Fruit'
      fruits[current_item_key] = current_item_value
    end

    counter += 1

  end
  fruits

end

produce = {
  'apple' => 'Fruit',
  'carrot' => 'Vegetable',
  'pear' => 'Fruit',
  'broccoli' => 'Vegetable'
}



p select_fruit(produce) # => {"apple"=>"Fruit", "pear"=>"Fruit"}
