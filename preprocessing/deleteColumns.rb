# delete all columns after last-0-index one
last = 2

start = Time.now
puts 'Read and write file'
input = 'user_ratedmovies.dat'
output = 'ml-hr_urm.dat'
separator = "\t"

File.open(output, 'w') do |file|
  File.foreach(input) do |line|
    parts = line.split(separator)
    # Don't take more parts than available
    last_index = [parts.count-1, last].min
    (0..(last_index-1)).each do |i|
      file.write("#{parts[i]}\t")
    end
    file.write("#{parts[last_index]}\n")
  end
end
puts "Finished in #{Time.now - start} seconds"