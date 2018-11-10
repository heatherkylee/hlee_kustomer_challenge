class CustomerDataExport
  
  # import data from csv file
  def initialize
    @customers = CSV.read('sample1.csv', headers: true).to_a
  end

end
