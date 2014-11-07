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
		expect(err[:errCode]).to eq Jobposting::ERR_BAD_COMPANY_ID
	end

	it "should check that job title is valid" do
		Company.add("1","Banking services")
		err = Jobposting.add(1, "", "full-time", info="")
		expect(err[:errCode]).to eq Jobposting::ERR_TITLE
		err = Jobposting.add(1, "1"*129, "full-time", info="")
		expect(err[:errCode]).to eq Jobposting::ERR_TITLE
	end

	it "should check that job type is valid" do
		Company.add("1","Banking services")
		err = Jobposting.add(1, "Slave Labor", "24-7", info="")
		expect(err[:errCode]).to eq Jobposting::ERR_BAD_TYPE
	end

	it "should check that job info is valid" do
		Company.add("1","Banking services")
		err = Jobposting.add(1, "Job", "internship", info="1"*128*129)
		expect(err[:errCode]).to eq Jobposting::ERR_INFO_LENGTH
	end

	# Test show methods
	it "should show posting given correct id" do
		Company.add("ABC","Banking services")
		Jobposting.add(1, "Job", "internship", info="Free Labor")
		post = Jobposting.show_by_company_id(1)
		# print post
		expect(post[:value][0][:company_name]).to eq 'ABC'
	end

	it "should check that the input id are valid" do
		err = Jobposting.show_by_posting_id(10)
		expect(err[:errCode]).to eq Jobposting::ERR_BAD_POSTING_ID
		err = Jobposting.show_by_company_id(10)
		expect(err[:errCode]).to eq Jobposting::ERR_BAD_COMPANY_ID
	end

	# Test simple search
	it "should be able to search a post" do
		Company.add("B","Software Development")
		Jobposting.add(1, "Software Engineer", "full-time", info="")
		Jobposting.add(1, "Software Engineer", "part-time", info="")
		expect(Jobposting.simple_search("full-time")[:value][0][:job_type]).to eq "full-time"
	end

	# Test advanced search
	it "should return search results in correct order" do
		Company.add("B","Software Development")
		Jobposting.add(1, "Software Engineer", "part-time", info="machine learning")
		Jobposting.add(1, "Data Scientist", "full-time", info="requires machine learning skills", skills="python")
		Jobposting.add(1, "", "part-time", info="machine learning")
		best = Jobposting.ranked_search("machine learning, python")[:value]
		# Should match both postings
		expect(best.length).to eq 2
		# Second posting should rank higher due to skills tag
		print best
		expect(best[0][1]).to eq 1
		expect(best[0][0][:title]).to eq "Data Scientist"
	end

	# Test delete
	it "should check that posting to be removed exists" do
		err = Jobposting.remove(1)
		expect(err[:errCode]).to eq Jobposting::ERR_BAD_POSTING_ID
	end

	it "should delete posting if posting id exists" do
		Company.add("ABC","Banking services")
		Jobposting.add(1, "Job", "internship", info="Free Labor")
		err = Jobposting.remove(1)
		expect(err[:errCode]).to eq Jobposting::SUCCESS
	end

end
