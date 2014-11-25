class JobpostingController < ApplicationController
  before_action :set_jobposting, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :add

  SUCCESS = 1
  ERR_BAD_PERMISSIONS = -6
  ERR_DUPE_BOOKMARKS = -7

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
    # a hack so we don't have to deal with devise for testing
    # REMOVE DURING ACTUAL RELEASE!!!
    hack = params[:hack]
    if hack == 1296
      title        = params[:title]
      job_type     = params[:job_type]
      info         = params[:info]
      skills       = params[:skills]
      tags         = params[:tags]
      company_name = params[:company_name]
      company      = Company.find_by(company_name: company_name)
      ret = Jobposting.add(company.id, title, job_type, info, skills, tags)
      render json: ret
      return
    end

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
    # render json: ret
    @jobposting = ret[:value]
    render template: "users/jobs"
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
    @jobposting = ret[:value]
    render template: "users/jobs"
    # render json: ret
  end

  def search
    query = params[:q]
    ret = Jobposting.simple_search(query)
    @jobposting = ret[:value]
    render template: "users/jobs"
    #render json: ret
    # ret[:value]. 
  end

  def advanced_search
    query = params[:q]
    ret = Jobposting.ranked_search(query, current_user.saved_tags)
    postings = ret[:value]
    @jobposting = postings.map {|p, s| p}
    render template: "users/jobs"
    # render json: ret
  end

  ## PUT /jobposting/click/:id
  # This is called whenever a student clicks on a job posting. Updates the user history with posting tags.
  def click
    def increment(weight)
      ret = weight + 1.0 / (weight + 1.0)
      if ret > 10.0:
        ret = 10.0
      end
      return ret
    end

    if current_user.type == "Student"    
      posting_id = params[:id]
      post = Jobposting.find_by_posting_id(posting_id)
      if !post.blank?
        saved_tags = current_user.saved_tags
        tags = post.skills.split(", ") + post.tags.split(", ")
        tags.each do |t|
          if saved_tags.member?(t)
            saved_tags[t][:count ] = saved_tags[t][:count] + 1     # Increment counter by 1
            saved_tags[t][:weight] = increment(saved_tags[t][:weight])
          else
            saved_tags[t] = { count: 1, weight: 1.0 }    # Add tag into history and initialize counter
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
    bookmarks = current_user.bookmarks
    if Jobposting.find_by_posting_id(posting_id).blank?
      err = Jobposting::ERR_BAD_POSTING_ID
    elsif current_user.bookmarks.include?(posting_id)
      bookmarks.delete(posting_id.to_s)
      current_user.update(bookmarks: bookmarks)
      err = ERR_DUPE_BOOKMARKS # successfully removes bookmarks
    else
      bookmarks = bookmarks + [posting_id]
      current_user.update(bookmarks: bookmarks)
      err = SUCCESS
    end
    respond_to do |format|
      format.json { render json: { errCode: err } }
      format.html { render template: "users/post" }   # not sure which template to use, feel free to edit
    end
    
  end

  ## GET /jobposting/bookmarks
  # This is for retrieving the current user's bookmarks.
  # Output: Array of job postings
  def retrieve_bookmarks
    # todo: what if bookmarked posting was deleted?
    postings = current_user.bookmarks.map { |b| b.to_i }
    # print postings
    # @jobposting = Jobposting.where("posting_id = ?", postings)   # note if no bookmarks, will return nil
    @jobposting = Array.new(postings.length) { Jobposting }
    postings.each_with_index do |p,i|
      @jobposting[i] = Jobposting.find_by_posting_id(p)
    end
    # @jobposting = Jobposting.find(postings)
    respond_to do |format|
      format.json { render json: { errCode: SUCCESS, value: @jobposting } }
      format.html { render template: "users/dashboard" }   # not sure which template to use, feel free to edit
    end

  end

  # GET /jobposting/recommendation
  def recommend
    query = ""
    ret = Jobposting.ranked_search(query, current_user.saved_tags, true)
    postings = ret[:value]
    @jobposting = postings.map {|p, s| p}
    render json: ret
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
