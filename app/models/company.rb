class Company < ActiveRecord::Base

	SUCCESS = 1
	ERR_COMPANY_EXISTS = -1
	ERR_COMPANY_NAME = -2
	ERR_UNKNOWN_ID = -3

	validates :company_name, uniqueness: true, presence: true

	

	def self.add(name, info)

		@last_company = Company.last()
		if @last_company.blank?
			current_id = 1
		else
			current_id = @last_company.company_id + 1
		end

		@company = Company.new(company_id: current_id, company_name: name, company_info: info)
		if @company.valid?
			@company.save
			err = SUCCESS
		else
			if Company.exists?(company_name: name)
				err = ERR_COMPANY_EXISTS
			else name.blank?
				err = ERR_COMPANY_NAME
			end
		end
		return err

	end

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
