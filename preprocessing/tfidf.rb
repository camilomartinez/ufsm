# Relative frequency of a term within a document
def tf(term_freq, n_terms_document, item, feature)
  term_freq[item][feature].to_f / n_terms_document[item]
end

# Computes inverse document frequency for a term
def idf(document_freq, n_documents, feature)
  Math.log( (1+n_documents).to_f / (1+document_freq[feature]) );
end

separator = '|'
output_file = 'output/tfIdf.dat'
puts 'Read contiguousIcm'
input_file = 'output/contiguousIcm.dat'
is_header = true
# Number of feature occurrences per item
# term_frequency[item][feature]
term_freq = {}
#Number of terms per document
# n_terms_document[item]
n_terms_document = {}
# Number of items with a feature
# document_freq[feature]
document_freq = {}
n_documents = 0
File.foreach(input_file) do |line|
  # Skip first line as it is the header
  if is_header
    is_header = false
    next
  end
  parts = line.split(separator)
  item = parts[0].chomp.to_i
  feature = parts[1].chomp.to_i
  occurrences = parts[2].chomp.to_i
  # update number of documents
  n_documents = item if item > n_documents
  # Set occurrences
  term_freq[item] = {} unless term_freq.key? item
  term_freq[item][feature] = occurrences
  # Count term appearance
  n_terms_document[item] = 0 unless n_terms_document.key? item
  # Optionally this appearance could be counted only once
  n_terms_document[item] += occurrences
  document_freq[feature] = 0 unless document_freq.key? feature
  document_freq[feature] += 1
end

puts 'Creating output file'
is_header = true
File.open(output_file, 'w') do |file|
  File.foreach(input_file) do |line|
    # Skip first line as it is the header
    if is_header
      is_header = false
      #Header
      line_to_write = "ItemId|FeatureId|TfIdf\n"
      file.write(line_to_write)
      next
    end
    parts = line.split(separator)
    item = parts[0].chomp.to_i
    feature = parts[1].chomp.to_i
    tf_idf = tf(term_freq, n_terms_document, item, feature) * idf(document_freq, n_documents, feature)
    line_to_write = "#{item}|#{feature}|#{tf_idf}\n"
    file.write(line_to_write)
  end
end