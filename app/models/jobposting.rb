class Jobposting < ActiveRecord::Base

SUCCESS            =   1
ERR_BAD_POSTING_ID =  -1
ERR_TITLE          =  -2
ERR_BAD_COMPANY_ID =  -3
ERR_BAD_TYPE       =  -4
MAX_TITLE_LENGTH   = 128
MAX_INFO_LENGTH    = 128*128
ALLOWED_TYPES      = ['full-time', 'internship', 'part-time']

  def self.add(company_id, title, job_type, info="")
    # verify title:
    if title == "" or title.length > MAX_TITLE_LENGTH
      return {errcode: ERR_TITLE}
    end
    # verify company_name, company_id:
    company = Company.find_by(company_id: company_id)
    if company.blank?
      return {errcode: ERR_BAD_COMPANY_ID}
    else
      company_name = company.company_name
    end
    # verify job_type:
    if not ALLOWED_TYPES.include?(job_type)
      return {errcode: ERR_BAD_TYPE}
    end
    # verify info:
    if info.length > MAX_INFO_LENGTH
      return {errCode: ERR_INFO_LENGTH}
    end

    last_posting = Jobposting.last()
    if last_posting.blank?
        posting_id = 1
    else
        posting_id = last_posting.posting_id + 1
    end

    # create a job posting:
    Jobposting.create(posting_id: posting_id, title: title,
                      company_name: company_name, company_id: company_id,
                      job_type: job_type, info: info)
    return {errCode: SUCCESS}
  end

  def self.show_all()
    posting = Jobposting.all
    return {errCode: SUCCESS, value: posting}
  end

  def self.show_by_posting_id(posting_id)
    posting = Jobposting.find_by(posting_id: posting_id)
    if posting == nil
      return {errCode: ERR_BAD_POSTING_ID}
    end
    return {errCode: SUCCESS, value: posting}
  end

  def self.show_by_company_id(company_id)
    posting = Jobposting.where("company_id = ?", company_id)
    if posting == nil
      return {errCode: ERR_BAD_COMPANY_ID}
    end
    return {errCode: SUCCESS, value: posting}
  end

  def self.search(query)
    q = "%"+query+"%"
    posting = Jobposting.where("title like ? OR company_name like ? OR job_type like ? OR info like ?", q, q, q, q)
    return {errCode: SUCCESS, value: posting}
  end

  def self.remove(posting_id, company_id)
    if Jobposting.findby(posting_id: posting_id, company_id: company_id) == nil
        return {errCode: ERR_BAD_POSTING_ID}
    end
    Jobposting.delete(posting_id: posting_id, company_id: company_id)
    return {errCode: SUCCESS}
  end

  def self.TESTAPI_resetFixture()
    Jobposting.delete_all()
    return {errCode: SUCCESS}
  end
end
