class CustomerDataImport
  
  # import data from csv file
  def initialize
    @customers = CSV.read('sample1.csv', headers: true).to_a
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
    @output = []
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
      @output << JSON.pretty_generate(customer_data)
    end
    puts cleaned_data = @output
  end
end 

formatted_data = CustomerDataExport.new.import_data
