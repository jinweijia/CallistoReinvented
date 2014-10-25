require 'rails_helper'

RSpec.describe Company, :type => :model do

	# Test add method
	it "should add a company given the correct inputs" do
		Company.add("A","") # Test for blank info
		Company.add("B","Software Development")
		Company.add("C","Banking services")
		expect(Company.count).to eq 3
	end

	it "should check that all company names are unique" do
		err = Company.add("A","")
		expect(err).to eq Company::SUCCESS
		err = Company.add("A","something different")
		expect(err).to eq Company::ERR_COMPANY_EXISTS
	end

	it "should check that company name is not blank" do
		err = Company.add("","")
		expect(err).to eq Company::ERR_COMPANY_NAME		
	end

	# Test get method
	it "should get company name and info by id" do
		Company.add("ABC","Pyramid Scheme")
		err, name, info = Company.get(1)
		expect(name).to eq "ABC"
		expect(info).to eq "Pyramid Scheme"
	end

	it "should check that input id is valid" do
		err = Company.get(-1)
		expect(err).to eq Company::ERR_UNKNOWN_ID
		err = Company.get(10)
		expect(err).to eq Company::ERR_UNKNOWN_ID
	end

end
