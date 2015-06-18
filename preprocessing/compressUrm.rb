require 'set'

start = Time.now
puts 'Read item cache'
#Read itemCache
itemCacheFile = 'itemcache_icm.dat'
separator = '|'
isHeader = true
itemCache = {}
File.foreach(itemCacheFile) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  itemCache[parts[0]] = parts[1].chomp
end
# Size check
raise 'Wrong item cache size' unless itemCache.size == 6489
puts "Elapsed so far #{Time.now - start} seconds"

puts 'Read urm'
# Read all user Ids in URM
urmFile = 'urm.dat'
isHeader = true
userIdSet = SortedSet.new
Preference = Struct.new(:userId, :itemId, :rating)
preferences = []
File.foreach(urmFile) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  userId = parts[0].to_i
  itemId = parts[1]
  rating = parts[2].chomp
  preferences << Preference.new(userId, itemId, rating)
  userIdSet.add userId
end
raise 'Wrong user id set size' unless userIdSet.count == 247939
# Build user cache
userCache = {}
newId = 1
userIdSet.each do |oldId|
  userCache[oldId] = newId
  newId += 1
end
puts "Elapsed so far #{Time.now - start} seconds"

puts 'Write urm'
# Replace user and item ids using cache
urmNewFile = 'urmCache.dat'
File.open(urmNewFile, 'w') do |file|
  #Header
  lineToWrite = "USERID|ITEMID|RATING\n"
  file.write(lineToWrite)
  preferences.each do |preference|
    newUserId = userCache[preference.userId]
    newItemId = itemCache[preference.itemId]
    lineToWrite = "#{newUserId}|#{newItemId}|#{preference.rating}\n"
    file.write(lineToWrite)
  end
end
puts "Finished in #{Time.now - start} seconds"