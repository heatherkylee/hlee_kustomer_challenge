require 'csv'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'
require 'date'

CSV.foreach("sample1.csv", headers: true, header_converters: :symbol) do |row|  
  
  row.to_h

  tag_list = []

  @tap_hash = Hash.new.tap do |hash|
    hash["name"] ="#{row[:firstname]} #{row[:lastname]}" if row[:firstname] && row[:lastname] 
    # hash[:emails] = Hash.new([]).tap do |email|
    hash["emails"] = Array.new().push(
        Hash.new.tap do |email|
          email["email"] = row[:email] if row[:email]
        end
      )

    if row[:homephone] || row [:workphone] 
      hash["phones"] = Array.new() 

      home = Hash.new.tap do |phone1|
        phone1["type"] = "home" if row[:homephone]
        phone1["phone"] = row[:homephone] if row[:homephone]
      end
      hash["phones"] << home
 

      work = Hash.new.tap do |phone2|
        phone2["type"] = "work" if row[:workphone]
        phone2["phone"] = row[:workphone] if row[:workphone]
      end
      hash["phones"] << work
    end

    hash["tags"] = tag_list << row[:customertype] if row[:customertype]
    hash["birthdayAt"] = DateTime.strptime(row[:birthday], "%a %b %d %Y %H:%M:%S %Z") if row[:birthday]
  end

  # p json_data = @tap_hash.to_json
  puts JSON.pretty_generate(@tap_hash)

  File.open("data5.json","a") do |f|
    f.write(@json_data)
  end
  
  # url = URI("https://api.kustomerapp.com/v1/customers")

  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # request = Net::HTTP::Post.new(url)
  # request["authorization"] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViZTNiNGJlYmZiYTU0MDA4ZTVjNGYxOSIsInVzZXIiOiI1YmUzYjRiZTNjODAyNjAwMTkzMGJhMDMiLCJvcmciOiI1YmUzNTJiNDNjODAyNjAwMTkyOGYzNjciLCJvcmdOYW1lIjoienp6LWhlYXRoZXIiLCJ1c2VyVHlwZSI6Im1hY2hpbmUiLCJyb2xlcyI6WyJvcmcuYWRtaW4iLCJvcmcudXNlciJdLCJleHAiOjE1NDIyNTQzOTcsImF1ZCI6InVybjpjb25zdW1lciIsImlzcyI6InVybjphcGkiLCJzdWIiOiI1YmUzYjRiZTNjODAyNjAwMTkzMGJhMDMifQ.jXv1zUdGtB_wbM8ySbitW4HHyfy4qytP4tqF5hM72nY'
  # request["content-type"] = 'application/json'
  # request.body = (@json_data)

  # response = http.request(request)
  # puts response.read_body
end
