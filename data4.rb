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
    type: "home",
    phone: ""
  },
  {
    type: "work",
    phone: ""
  }],
  tags: [
    type: ""
  ],
  birthdayAt: "" 
}

CSV.foreach("data.csv", headers: true, header_converters: :symbol) do |row|  
  row.to_h

  # create full name
  if row[:firstname] == nil  && row[:lastname] == nil
    true
  else
    @fullname = "#{row[:firstname]} #{row[:lastname]}"
  end

  # parse birthday to date-time format
  if row[:birthday] == nil
    true
  else
    birthday = row[:birthday]
    format = "%a %b %d %Y %H:%M:%S %Z"
    @birthday_at = DateTime.strptime(birthday, format) 
  end

  @convert_to_json_hash =
    {
    name: @fullname.to_s,
    emails: [
      {
      email: row[:email].to_s
      }
    ],
    phones: [
    {
      type: "home",
      phone: row[:homephone].to_s
    },
    {
      type: "work",
      phone: row[:workphone].to_s
    }
  ],
    tags: [
      row[:customertype].to_s
    ],
    birthdayAt: @birthday_at
  }

  @convert_to_json_hash
  json_data = @convert_to_json_hash
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
  request.body = (@convert_to_json_hash.to_json)

  response = http.request(request)
  puts response.read_body
end

