class JobpostingController < ApplicationController
  before_action :set_jobposting, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :add

  SUCCESS = 1
  ERR_BAD_PERMISSIONS = -6

  # For internal use only
  def validate_user_company(company)    
    
    # Validates that company exists
    if company == nil
      ret = { errCode: Jobposting::ERR_BAD_COMPANY_ID }
    # Validates that user has permission to add posting to the company
    elsif current_user.type != "Employer" || current_user.company_name != company.company_name
      ret = { errcode: ERR_BAD_PERMISSIONS }
    else
      ret = { errCode: Jobposting::SUCCESS }
    end
    return ret
  end

  def add

    title      = params[:title]
    job_type   = params[:job_type]
    info       = params[:info]
    skills     = params[:skills]
    tags       = params[:tags]

    company    = Company.find_by(company_name: current_user.company_name)
    ret = validate_user_company(company)

    print "validation returns:"
    print ret

    if ret[:errCode] == 1          
      ret = Jobposting.add(company.id, title, job_type, info, skills, tags)
    end
    print ret
    render json: ret

  end

  def create
  end

  def update

    posting_id = params[:id]
    title      = params[:title]
    job_type   = params[:job_type]
    info       = params[:info]
    skills     = params[:skills]
    tags       = params[:tags]

    ret = Jobposting.update(posting_id, title, job_type, info, skills, tags)
    render json: ret

  end

  def show_all
    ret = Jobposting.show_all()
    render json: ret
  end

  def show_by_posting_id
    posting_id = params[:id]
    puts posting_id
    ret = Jobposting.show_by_posting_id(posting_id)
    @jobposting = ret[:value]
    render template: "users/post"
    #render json: ret
  end

  def show_by_company_id
    company_id = params[:id]
    ret = Jobposting.show_by_company_id(company_id)
    render json: ret
  end

  def search
    query = params[:q]
    ret = Jobposting.simple_search(query)
    render json: ret
  end

  def advanced_search
    query = params[:q]
    ret = Jobposting.ranked_search(query, current_user.saved_tags)
    render json: ret
  end

  ## PUT /jobposting/click/:id
  # This is called whenever a student clicks on a job posting. Updates the user history with posting tags.
  def click

    if current_user.type == "Student"    
      posting_id = params[:id]
      post = Jobposting.find_by_posting_id(posting_id)
      if !post.blank?
        saved_tags = current_user.saved_tags
        tags = post.skills.split(", ") + post.tags.split(", ")
        tags.each do |t|
          if saved_tags.member?(t)
            saved_tags[t] = saved_tags[t] + 1    # Increment counter by 1
          else
            saved_tags[t] = 1    # Add tag into history and initialize counter
          end
        end
        current_user.update(saved_tags: saved_tags)
        render json: {errCode: 1}
      else
        render json: {errCode: Jobposting::ERR_BAD_POSTING_ID}
      end
    else
      render json: {errCode: ERR_BAD_PERMISSIONS}
    end

  end

  ## PUT /jobposting/bookmark/:id
  # This is called whenever a student bookmarks a job posting. Updates the user bookmarks with posting id.
  def bookmark
    posting_id = params[:id]
    if Jobposting.find_by_posting_id(posting_id).blank?
      err = Jobposting::ERR_BAD_POSTING_ID
    else
      bookmarks = current_user.bookmarks + [posting_id]
      current_user.update(bookmarks: bookmarks)
      err = SUCCESS
    end
    render json: { errCode: err }
  end

  ## GET /jobposting/bookmarks
  # This is for retrieving the current user's bookmarks.
  # Output: Array of job postings
  def retrieve_bookmarks

  end

  ##
  # delete method validates whether current user has permissions to delete company before calling
  # Jobposting.remove().
  # Arguments: company_id, posting_id
  # Output: error code in json
  def delete
    
    company = Company.find_by(company_name: current_user.company_name)
    ret = validate_user_company(company)

    if ret[:errCode] == 1
      posting_id = params[:posting_id]
      ret = Jobposting.remove(posting_id)
    end
    render json: ret
  end

end
