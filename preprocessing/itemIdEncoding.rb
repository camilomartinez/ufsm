start = Time.now
puts 'Encode using item title'
input_file = '../data/details/titlefull_icm.dat'
output_file = 'output/itemIdEncoding.dat'
separator = '|'
isHeader = true
File.open(output_file, 'w') do |file|
  #Header
  lineToWrite = "ItemId|ItemIdCode\n"
  file.write(lineToWrite)
  File.foreach(input_file) do |line|
    # Skip first line as it is the header
    if isHeader
      isHeader = false
      next
    end
    parts = line.split(separator)
    itemId = parts[1].chomp.to_i
    itemIdCode = parts[0].chomp.to_i
    lineToWrite = "#{itemId}|#{itemIdCode}\n"
    file.write(lineToWrite)
  end
end