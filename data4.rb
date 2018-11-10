# attempt to upload rows one at a time
require 'csv'
require 'json'
require 'uri'
require 'net/http'
require 'openssl'


@convert_to_json_hash = {
  name: "",
  emails: [
    email: "" 
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

array = []
CSV.foreach("data.csv", headers: true, header_converters: :symbol) do |row|  
  row.to_h
  
  if row[:firstname] == nil  && row[:lastname] == nil
    true
  else
    fullname = "#{row[:firstname]} #{row[:lastname]}"
  end

  @convert_to_json_hash =
    {
    name: fullname.to_s,
    emails: [
      email: row[:email].to_s
    ],
    phones: [
    {
      type: "home",
      phone: row[:homephone].to_s
    },
    {
      type: "work",
      phone: row[:workphone].to_s
    }],
    tags: [
      type: row[:customertype].to_s
    ],
    birthdayAt: row[:birthday].to_s
  }

  # p @convert_to_json_hash
  p json_data = @convert_to_json_hash.to_json
  # File.open("data4.json","w") do |f|
    # f.write(array.to_json)
  # end
  # url = URI("https://api.kustomerapp.com/v1/customers")

  # http = Net::HTTP.new(url.host, url.port)
  # http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # request = Net::HTTP::Post.new(url)
  # request["authorization"] = 'Bearer APIKEY'
  # request["content-type"] = 'application/json'
  # request.body = json_data

  # response = http.request(request)
  # puts response.read_body
end

