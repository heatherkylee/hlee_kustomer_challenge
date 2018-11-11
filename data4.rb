# attempt to upload rows one at a time
require 'csv'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'
require 'date'


@convert_to_json_hash = {
  name: "",
  emails: [
    {
      email: "" 
    }
  ],
  phones: [
  {
    type: "",
    phone: ""
  }],
  tags: [],
  birthdayAt: "" 
}

CSV.foreach("sample1.csv", headers: true, header_converters: :symbol) do |row|  
  row.to_h

  # puts row
  # p "*" * 10

  # create full name
  if row[:firstname] == nil  && row[:lastname] == nil
    @fullname = nil
  else
    @fullname = "#{row[:firstname]} #{row[:lastname]}"
  end

  # parse birthday to date-time format
  if row[:birthday] == nil
    @birthday_at = nil
  else
    birthday = row[:birthday]
    format = "%a %b %d %Y %H:%M:%S %Z"
    @birthday_at = DateTime.strptime(birthday, format) 
  end

  # create home phone type
  if row[:homephone] == nil
    @phonetype_home = nil
    @phonenumber_home = nil
  else
    @phonenumber_home = row[:homephone]
    @phonetype_home = "home"
  end  

  # create work phone type
  if row[:workphone] == nil
    @phonetype_work = nil
    @phonenumber_work = nil
  else
    @phonetype_work = "work"
    @phonenumber_work = row[:workphone]
  end
# 
 #create customer tag
  if row[:customertype] == nil
    @tag = nil
  else
    @tag = row[:customertype]
  end

  @convert_to_json_hash =
    {
    name: @fullname,
    emails: [
      {
      email: row[:email]
      }
    ],
    phones:[
    {
      type: @phonetype_home,
      phone: @phonenumber_home
    },
    {
      type: @phonetype_work,
      phone: @phonenumber_work
    }
  ],
    tags: [@tag],
    birthdayAt: @birthday_at
  }

  # p json_data = @convert_to_json_hash
  # puts JSON.pretty_generate(@convert_to_json_hash)

  # File.open("data4.json","a") do |f|
  #   f.write(@convert_to_json_hash.to_json)
  # end
  
  url = URI("https://api.kustomerapp.com/v1/customers")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["authorization"] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjViZTNiNGJlYmZiYTU0MDA4ZTVjNGYxOSIsInVzZXIiOiI1YmUzYjRiZTNjODAyNjAwMTkzMGJhMDMiLCJvcmciOiI1YmUzNTJiNDNjODAyNjAwMTkyOGYzNjciLCJvcmdOYW1lIjoienp6LWhlYXRoZXIiLCJ1c2VyVHlwZSI6Im1hY2hpbmUiLCJyb2xlcyI6WyJvcmcuYWRtaW4iLCJvcmcudXNlciJdLCJleHAiOjE1NDIyNTQzOTcsImF1ZCI6InVybjpjb25zdW1lciIsImlzcyI6InVybjphcGkiLCJzdWIiOiI1YmUzYjRiZTNjODAyNjAwMTkzMGJhMDMifQ.jXv1zUdGtB_wbM8ySbitW4HHyfy4qytP4tqF5hM72nY'
  request["content-type"] = 'application/json'
  request.body = (JSON.pretty_generate(@convert_to_json_hash))

  response = http.request(request)
  puts response.read_body
end

