class Jobposting < ActiveRecord::Base

SUCCESS            =   1
ERR_BAD_POSTING_ID =  -1
ERR_TITLE          =  -2
ERR_BAD_COMPANY_ID =  -3
ERR_BAD_TYPE       =  -4
ERR_INFO_LENGTH    =  -5
MAX_TITLE_LENGTH   = 128
MAX_INFO_LENGTH    = 128*128
ALLOWED_TYPES      = ['full-time', 'internship', 'part-time']

  # serialize :skills, Hash
  # serialize :tags, Hash

  def self.add(company_id, title, job_type, info="", skills="", tags="")
    # verify title:
    if title == "" or title.length > MAX_TITLE_LENGTH
      return {errCode: ERR_TITLE}
    end
    # verify company_id:
    company = Company.find_by(company_id: company_id)
    if company.blank?
      return {errCode: ERR_BAD_COMPANY_ID}
    else
      company_name = company.company_name
    end
    # verify job_type:
    if not ALLOWED_TYPES.include?(job_type)
      return {errCode: ERR_BAD_TYPE}
    end
    # verify info:
    if info.length > MAX_INFO_LENGTH
      return {errCode: ERR_INFO_LENGTH}
    end

    # use id = 1 for the first time, then increment for each new posting
    last_posting = Jobposting.last()
    if last_posting.blank?
        posting_id = 1
    else
        posting_id = last_posting.posting_id + 1
    end

    # skills and tags stored as a string for easier simple search
    # pskills = skills.split(", ")
    # ptags = tags.split(", ")

    # create a job posting:
    @jobposting = Jobposting.new(posting_id: posting_id, title: title,
                      company_name: company_name, company_id: company_id,
                      job_type: job_type, info: info, skills:skills, tags:tags)
    @jobposting.save
    return {errCode: SUCCESS}
  end

  def self.show_all()
    # return all postings
    posting = Jobposting.all
    return {errCode: SUCCESS, value: posting}
  end

  def self.show_by_posting_id(posting_id)
    # attempt to find a posting that matches posting_id
    posting = Jobposting.find_by(posting_id: posting_id)
    # return an error if not found
    if posting == nil
      return {errCode: ERR_BAD_POSTING_ID}
    end
    return {errCode: SUCCESS, value: posting}
  end

  def self.show_by_company_id(company_id)
    # attempt to find all postings that matches company_id
    posting = Jobposting.where("company_id = ?", company_id)
    # return an error if not found
    if posting.length == 0
      return {errCode: ERR_BAD_COMPANY_ID}
    end
    return {errCode: SUCCESS, value: posting}
  end

  def self.simple_search(query)
    # do a fuzzy over all fields that are string types and see if any match occurs
    q = "%"+query+"%"
    posting = Jobposting.where("title like ? OR company_name like ? OR job_type like ? OR info like ?", q, q, q, q)
    return {errCode: SUCCESS, value: posting}
  end

  def self.ranked_search(query)
    
    # First narrow down the list of matching postings // use Jobposting.find_each for large database (supports batch retrieval)
    # q = "%"+query+"%"
    # posting = Jobposting.where("title like :keyword OR company_name like :keyword OR job_type like :keyword OR info like :keyword OR skills like :keyword OR tags like :keyword", {keyword: q})

    query = query.split(", ")

    # Rank postings
    rankings = Hash.new
    Jobposting.find_each do |post|
      # Score is used to determine ranking
      score = -1
      tag_matches = 0
      skills = post.skills.split(", ")
      tags = post.tags.split(", ")
      search_scope_simple = [post.title, post.company_name, post.job_type, post.info, post.skills, post.tags]

      query.each do |keyword|        
        # First determine if this post is relevant, if not already done
        if score < 0        
          search_scope_simple.each do |s|
            if s.include?(keyword)
              # This posting is relevant, break out of for loop
              score = 0
              break
            end
          end
        end
        # Check if keyword matches any tags
        if skills.include?(keyword) or tags.include?(keyword)           
          tag_matches += 1
        end        
      end
      # If posting is relevant, run algorithm to compute weight
      if score == 0
        score = tag_matches
        # todo: score increment can vary according to user preference
        # requires: current_user.saved_tags // should be a hash mapping tags to frequency
        # condition 1: keyword appears in user's saved tags

        rankings[post] = score
      end                
    end
    # This line returns a nested array of [post, score] pairs
    result = rankings.sort_by { |post, score| score }.reverse!

    return result

  end

  def self.remove(posting_id, company_id)
    # find a posting that matches both posting_id and company_id, if so, delete, else error
    if Jobposting.find_by(posting_id: posting_id, company_id: company_id) == nil
        return {errCode: ERR_BAD_POSTING_ID}
    end
    Jobposting.delete(posting_id: posting_id, company_id: company_id)
    return {errCode: SUCCESS}
  end

  def self.TESTAPI_resetFixture()
    Jobposting.delete_all()
    return {errCode: SUCCESS}
  end

  # Code for using hash to sort postings
  def ==(other)
    self.class === other and other.posting_id == @posting_id
  end

  alias eql? ==

  def hash
    @posting_id.hash
  end

end
