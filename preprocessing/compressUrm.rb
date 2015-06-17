require 'set'

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

# Read all user Ids in URM
urmFile = 'urm.dat'
isHeader = true
userIdSet = SortedSet.new
File.foreach(urmFile) do |line|
  # Skip first line as it is the header
  if isHeader
    isHeader = false
    next
  end
  parts = line.split(separator)
  userId = parts[0].to_i
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

# Replace user and item ids using cache
urmNewFile = 'urmCache.dat'
File.open(urmNewFile, 'w') do |file|
  File.foreach(urmFile) do |line|
    # First line is the header
    if isHeader
      lineToWrite = "USERID|ITEMID|RATING"
      file.write(lineToWrite)
      isHeader = false
      next
    end
    parts = line.split(separator)
    userId = parts[0].to_i
    itemId = parts[1]
    rating = parts[2]
    newUserId = userCache[userId]
    newItemId = itemCache[itemId]
    lineToWrite = "#{newUserId}|#{newItemId}|#{rating}"
    file.write(lineToWrite)
  end
end