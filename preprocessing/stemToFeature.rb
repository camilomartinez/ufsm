start = Time.now
puts 'Read item cache'
input_file = 'dictionary.dat'
output_file = 'stemToFeature.dat'
separator = '|'
isHeader = true
stemToFeatureId = {};
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  stem = parts[2].chomp
  featureId = parts[0].chomp
  stemToFeatureId[stem] = [] unless stemToFeatureId.key? stem
  stemToFeatureId[stem] << featureId
end

