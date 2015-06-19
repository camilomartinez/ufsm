require 'set'

start = Time.now
puts 'Read content file'
genreFile = 'movie_genres.dat'
genres = SortedSet.new
separator = "\t"
isHeader = true
Tag = Struct.new(:movieId, :genre)
tags = []
File.foreach(genreFile) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  movieId = parts[0].to_i
  genre = parts[1].chomp
  # Store tag
  tags << Tag.new(movieId, genre)
  # Store genre
  genres.add genre
end
puts "Time reading file #{Time.now - start} seconds"

#Generate genre cache
puts 'Generate genre cache'
genreCache = {}
genreId = 1
File.open('genre_cache.dat', 'w') do |file|
  #Header
  file.write("genreId\tgenre\n")
  genres.each do |genre|
    genreCache[genre] = genreId
    file.write("#{genreId}\t#{genre}\n")
    genreId += 1
  end
end
puts "Time after genre cache creation #{Time.now - start} seconds"

puts 'Write item content matrix'
# Replace genre id and place 1
icmFile = 'movie_icm.dat'
File.open(icmFile, 'w') do |file|
  #Header
  file.write("itemId\tfeatureId\tvalue\n")
  tags.each do |tag|
    genreId = genreCache[tag.genre]
    file.write("#{tag.movieId}\t#{genreId}\t1\n")
  end
end
puts "Finished in #{Time.now - start} seconds"

