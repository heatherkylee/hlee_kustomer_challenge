require 'csv'
require 'json'

class CustomerDataImport
  
  # import data from csv file
  def initialize
    @customers = CSV.read('data.csv', headers: true).to_a
  end

  # define type of phone number (work) through attribute name from data.csv
  def work_phone
    work_phone = @customers[0][5].to_s.split("")
    i = 0
    @work_phone_type = ""
    while i < 4
      @work_phone_type << work_phone[i]
      i += 1
    end
    @work_phone_type
  end
  
  # define tpye of phone number (home) through attribute name from data.csv
  def home_phone
    home_phone = @customers[0][4].to_s.split("")
    i = 0
    @home_phone_type = ""
    while i < 4
      @home_phone_type << home_phone[i]
      i += 1
    end
    @home_phone_type
  end

   #assign .csv data to attributes in nested array structure that is accepted by Kustomer API
  def import_data
    @formatted_data = []
    @customers.shift
    @customers.each do |customer|
      customer_data = {
        name: "#{customer[0]} #{customer[1]}",
        emails: [
          {
            type: "",
            email: customer[2]
          }
        ],
        phones: [
          {
            type: @home_phone_type,
            phone: customer[4]
          },
          {
            type: @work_phone_type,
            phone: customer[5]
          }
        ],
        type: customer[6],
        birthdayAt: customer[3]
        # socials: [
        #   {
        #     type: "",
        #     userid: "",
        #     username: "",
        #     url: ""
        #   }
        # ],
        # urls: [
        #   {
        #     url: ""
        #   }
        # ],
        # locations: [
        #   {
        #     type: "",
        #     address: ""
        #   }
        # ],
        # locale: "",
        # gender: "",
        # tags: [
        # ]
      }
      # p @formatted_data << JSON.pretty_generate(customer_data)

      @formatted_data << customer_data
    end
    File.open("data.json","w") do |f|
        f.write(@formatted_data.to_json)
      end
      File.open("nojsondata.json","w") do |f|
        f.write(@formatted_data)
      end
  end
end 

kustomer_data = CustomerDataImport.new.import_data
