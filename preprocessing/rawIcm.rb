separator = '|'
output_file = 'output/rawIcm.dat'
puts 'Read stemToFeature'
input_file = 'output/stemToFeature.dat'
isHeader = true
stemToFeatureId = {}
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  stem = parts[0].chomp
  featureId = parts[1].chomp.to_i
  stemToFeatureId[stem] = featureId
end
puts 'Read itemIdEncoding'
input_file = 'output/itemIdEncoding.dat'
isHeader = true
itemIdToCode = {}
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  itemId = parts[0].chomp.to_i
  itemCode = parts[1].chomp.to_i
  itemIdToCode[itemId] = itemCode
end

puts 'Read icm dat'
input_file = '../data/details/icm.dat'
isHeader = true
icm = {};
nItems = 0;
nFeatures = 0;
#i = 0
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  stem = parts[0].chomp
  itemId = parts[1].chomp.to_i
  numOcurrences = parts[2].chomp.to_i
  # encode
  featureId = stemToFeatureId[stem]
  itemCode = itemIdToCode[itemId]
  #Store max
  nFeatures = featureId if featureId > nFeatures
  nItems = itemCode if itemCode > nItems
  # icm is a double hash structure
  icm[itemCode] = {} unless icm.key? itemCode
  itemFeatures = icm[itemCode]
  itemFeatures[featureId] = 0 unless itemFeatures.key? featureId
  itemFeatures[featureId] += numOcurrences
  #puts "stem #{stem} encoded with feature id: #{featureId}"
  #puts "item id #{itemId} encoded with code: #{itemCode}"
  #puts "item #{itemCode} has #{numOcurrences} occurrences of feature #{featureId}"
  #i += 1
  #break if (i > 10)
end

File.open(output_file, 'w') do |file|
  #Header
  lineToWrite = "ItemId|FeatureId|NumOcurrences\n"
  file.write(lineToWrite)
  (1..nItems).each do |itemId|
    itemFeatures = icm[itemId]
    itemFeatures.keys.sort.each do |featureId|
      numOcurrences = itemFeatures[featureId]
      lineToWrite = "#{itemId}|#{featureId}|#{numOcurrences}\n"
      file.write(lineToWrite)
    end
  end
end