input = "ugkcyxxp"

require 'digest'
i = 0
indexes = []
while true do
  hash =   Digest::MD5.hexdigest(input+i.to_s)
  i = i+1
  indexes << hash if hash.start_with?("00000")
  # p hash
  break if indexes.length == 8
end

p indexes



