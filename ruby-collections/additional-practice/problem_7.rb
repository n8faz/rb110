# Create a hash that expresses the frequency with which each letter occurs in this string:

statement = "The Flintstones Rock"

occurences_hash = {}

statement.delete(" ").chars.each do |letter|
  occurences_hash[letter] = statement.chars.count(letter)
end

p occurences_hash
