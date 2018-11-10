# json file generated results in {"errors":[{"status":413,"code":"PayloadTooLargeError","title":"request entity too large"}]}

require 'csv'
require 'json'

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
    name: fullname,
    emails: [
      email: row[:email]
    ],
    phones: [
    {
      type: "home",
      phone: row[:homephone]
    },
    {
      type: "work",
      phone: row[:workphone]
    }],
    tags: [
      type: row[:customertype]
    ],
    birthdayAt: row[:birthday]
  }
  array << @convert_to_json_hash
  File.open("data3.json","a") do |f|
    f.write(array.to_json)
  end
end