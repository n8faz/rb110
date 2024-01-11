VALID_CHARACTERS = ['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']

def generate_uuid
  sections = [8, 4, 4, 4, 12]
  uuid = ''
  sections.each_with_index do |num, index|
    uuid << '-' unless index == 0
    uuid << generate_character(num)
  end
  uuid
end

def generate_character(amount)
  characters = ''
  amount.times do
    characters << VALID_CHARACTERS.sample
  end
  characters
end

p generate_uuid
