require "set"

separator = '|'
output_file = 'output/contiguousIcm.dat'
puts 'Read rawIcm'
input_file = 'output/rawIcm.dat'
is_header = true
item_id_set = SortedSet.new
feature_id_set = SortedSet.new
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if is_header
    is_header = false
    next
  end
  parts = line.split(separator)
  item_id = parts[0].chomp.to_i
  feature_id = parts[1].chomp.to_i
  #Include line in the set
  item_id_set.add item_id
  feature_id_set.add feature_id
end
puts 'Finished reading rawIcm'
puts "There are #{item_id_set.size} items with at least one feature"
puts "There are #{feature_id_set.size} features ocurring at least once"

puts 'Creating contiguous mapping'
item_id_to_code = {}
item_id_set.each_with_index { |itemId, itemCode| item_id_to_code[itemId] = itemCode + 1 }
feature_id_to_code = {}
feature_id_set.each_with_index { |featureId, featureCode| feature_id_to_code[featureId] = featureCode + 1 }
puts 'Finished creating mapping'

puts 'Creating output file'
is_header = true
File.open(output_file, 'w') do |file|
  File.foreach(input_file) do |line|
    # Skip first line as it is the header
    if is_header
      is_header = false
      #Header
      line_to_write = "ItemId|FeatureId|NumOccurrences\n"
      file.write(line_to_write)
      next
    end
    parts = line.split(separator)
    item_id = parts[0].chomp.to_i
    feature_id = parts[1].chomp.to_i
    num_occurrences = parts[2].chomp.to_i
    item_code = item_id_to_code[item_id]
    feature_code = feature_id_to_code[feature_id]
    line_to_write = "#{item_code}|#{feature_code}|#{num_occurrences}\n"
    file.write(line_to_write)
  end
end