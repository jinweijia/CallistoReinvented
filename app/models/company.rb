class Company < ActiveRecord::Base

	SUCCESS = 1
	ERR_COMPANY_EXISTS = -1
	ERR_COMPANY_NAME = -2
	ERR_UNKNOWN_ID = -3

	validates :company_name, uniqueness: true, presence: true

	##
	# Company.add method adds a company to the database. Has to check that company name does not
	# already exists and company name is not blank. It assigns an unique ID to each new company 
	# entry by incrementing the last added ID by 1.
	# Input: name and info
	# Output: error code
	def self.add(name, info)

		@last_company = Company.last()
		if @last_company.blank?
			current_id = 1
		else
			if @last_company.company_id.blank?
				current_id = 1
			else
				current_id = @last_company.company_id + 1
			end
		end

		@company = Company.new(company_id: current_id, company_name: name, company_info: info)
		if @company.valid?
			@company.save
			err = SUCCESS
		else
			if Company.exists?(company_name: name)
				err = ERR_COMPANY_EXISTS
			elsif name.blank?
				err = ERR_COMPANY_NAME
			end
		end
		return err

	end

	##
	# Company.get method retrives a company from the database based on its ID. Has to check that
	# a company with the ID exists.
	# Input: id
	# Output: error code, name, info
	def self.get(id)

		if Company.exists?(company_id: id)
			@company = Company.find_by_company_id(id)
			name = @company.company_name
			info = @company.company_info
			err = SUCCESS
			return err, name, info
		else
			err = ERR_UNKNOWN_ID
			return err
		end		

	end

	def self.resetFixture

		Company.delete_all
		result = SUCCESS

	end

end
