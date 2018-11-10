# code resulted in errors due to how it is being saved in the json file

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

CSV.foreach("data.csv", headers: true, header_converters: :symbol) do |row|  
  row.to_h
  
  if row[:firstname] == nil  && row[:lastname] == nil
    true
  else
    fullname = "#{row[:firstname]} #{row[:lastname]}"
  end

  @convert_to_json_hash = {
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
  File.open("data2.json","a") do |f|
    f.write(@convert_to_json_hash.to_json)
  end
end