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
end
