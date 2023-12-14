# add up all of the ages from the munster family hash

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }

sum_ages = 0

ages.each do |_name, age|
  sum_ages += age
end

p sum_ages
