# turn array into a hash where the names are the keys and the values are the positions in the array

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

flintstones_hash = {}
index = 0

flintstones.map do |name|
  flintstones_hash[name] = index
  index += 1
end

p flintstones_hash
