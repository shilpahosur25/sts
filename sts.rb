require 'csv'

#reading csv file and setting header=true
data=CSV.read("sample_data.csv",headers:true)


puts ("-----------------------------------------------")
# 1. The total number of records in the file.
puts ("1. Total number of records = " + data.size.to_s)

puts ("-----------------------------------------------")

# 2. The total number of unique email addresses in the file. 
puts ("2. Total number of unique email = " + data['email'].uniq.size.to_s)


puts ("-----------------------------------------------")
# Regex for email address
VALID_EMAIL_REGEX = /^[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/i

# Seperate out data into Valid data and Invalid data CSVs
valid_data = []
invalid_data = []
CSV.foreach("sample_data.csv",headers:true) do |row|
  if row[0] =~ VALID_EMAIL_REGEX
  	valid_data << row
  else
  	invalid_data << row
  end
end

# Build valid csv for further use
CSV.open("valid.csv", "wb") do |csv|
  valid_data.each{ |line| csv << line }
end

# Build invalid csv for further use - if any
CSV.open("invalid.csv", "wb") do |csv|
  invalid_data.each{ |line| csv << line }
end

# 3.The total number of valid email addresses in the file.\
puts ("3. Total number of records with valid email addresses = " + valid_data.size.to_s)

puts ("-----------------------------------------------")

# Re-run to check unique emails with valid email addresses
CSV.open('valid_uniq.csv', 'w') do |csv|
  CSV.read('valid.csv').uniq{|x| x[0]}.each do |row|
    csv << row
  end
end

valid_uniq_data = CSV.read("valid_uniq.csv")

# 3.The total number of valid and unique email addresses in the file.\
puts ("3. Total number of records with valid and unique email addresses = " + valid_uniq_data.size.to_s)

puts ("-----------------------------------------------")

# Lets split the email address with domain name as new column to sheet
CSV.open('final_data.csv', 'w', :write_headers=> true,
    :headers => ["email","first_name","last_name", "datetime", "domain"]) do |csv|
  CSV.foreach('valid_uniq.csv') do |row|
    csv << row + [row[0].split('@')[1].split('.')[0]]
  end
end

final = CSV.read("final_data.csv",headers:true)

# Use Hash, so that sorting is easier.
count_arr = Hash.new 0
final["domain"].each do |item|
  item = item.downcase
  count_arr[item] += 1
end

# 4. Sort by domain counts, descending order.
puts "4. Sort by domain counts, descending order:"
puts count_arr.sort_by{ |k, v| v }.reverse

puts ("-----------------------------------------------")
