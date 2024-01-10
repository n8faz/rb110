# Using the each method, write some code to output all of the vowels from the strings.

hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}

VOWELS = ['a','e','i','o','u']

all_vowels = ''
hsh.each_value do |array|
  array.each do |string|
    string.chars.each do |letter|
      all_vowels << letter if VOWELS.include?(letter)
    end
  end
end

p all_vowels
