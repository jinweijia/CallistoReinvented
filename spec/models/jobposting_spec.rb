require 'rails_helper'

RSpec.describe Jobposting, :type => :model do

	#Test add method
	it "should add job posting when given valid input" do
		Company.add("B","Software Development")
		Company.add("C","Banking services")
		Jobposting.add(1, "Software Engineer", "full-time", info="")
		Jobposting.add(1, "Software Engineer", "part-time", info="")
		Jobposting.add(2, "Investment Banker", "internship", info="")
		expect(Jobposting.count).to eq 3
	end

	it "should check that company id exists" do
		err = Jobposting.add(1, "Software Engineer", "full-time", info="")
		expect(err).to eq Jobposting::ERR_BAD_COMPANY_ID
	end

end
