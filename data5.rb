require 'csv'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'
require 'date'

CSV.foreach("data_notuploaded.csv", headers: true, header_converters: :symbol) do |row|  
  
  row.to_h

  @tap_hash = Hash.new.tap do |hash|
    # create fullname
    if row[:firstname] && row[:lastname] 
      hash["name"] ="#{row[:firstname]} #{row[:lastname]}" 
    elsif row[:firstname]
      hash["name"] = row[:firstname]
    elsif row[:lastname] 
    hash["name"] = row[:lastname] 
    end
    #end of create fullname

    hash["emails"] = Array.new().push(
        Hash.new.tap do |email|
          email["email"] = row[:email] if row[:email]
        end
      ) if row[:email]

    # phone numbers
    if row[:homephone] && row[:workphone]
      hash["phones"] = Array.new()
      # create home phone number
      home = Hash.new.tap do |phone1|
        phone1["type"] = "home" 
        phone1["phone"] = row[:homephone]
      end
      hash["phones"] << home
      # end of home phone number
      # create work phone number
      work = Hash.new.tap do |phone2|
        phone2["type"] = "work" if row[:workphone]
        phone2["phone"] = row[:workphone] if row[:workphone]
      end
      hash["phones"] << work
      # end of work phone number
    elsif row[:homephone]
      hash["phones"] = Array.new() 
      # create home phone number
      home = Hash.new.tap do |home_phone|
        home_phone["type"] = "home" 
        home_phone["phone"] = row[:homephone]
      end
      hash["phones"] << home
      # end of home phone number
    elsif row[:workphone] 
      # create work phone number
      hash["phones"] = Array.new() 
      work = Hash.new.tap do |work_phone|
        work_phone["type"] = "work" 
        work_phone["phone"] = row[:workphone]
      end
      hash["phones"] << work
    end
    # end phone numbers

    hash["tags"] = [] << row[:customertype] if row[:customertype]
    hash["birthdayAt"] = DateTime.strptime(row[:birthday], "%a %b %d %Y %H:%M:%S %Z") if row[:birthday]
  end

  # puts @json_data = JSON.pretty_generate(@tap_hash)

  # upload data to server one at a time

  url = URI("https://api.kustomerapp.com/v1/customers")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["authorization"] = 'Bearer API_KEY'
  request["content-type"] = 'application/json'
  request.body = (@json_data)
  # puts @json_data = JSON.pretty_generate(@tap_hash)
  # p "*" * 10
  response = http.request(request)
  puts response.read_body
end
