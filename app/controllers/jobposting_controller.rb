class JobpostingController < ApplicationController
  before_action :set_jobposting, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :add

  ERR_BAD_PERMISSIONS = -6

  # For internal use only
  def validate_user_company(company)    
    
    # Validates that company exists
    if company == nil
      ret = { errCode: Jobposting.ERR_BAD_COMPANY_ID }
    # Validates that user has permission to add posting to the company
    elsif current_user.type != "Employer" || current_user.company_name != company.company_name
      ret = { errcode: ERR_BAD_PERMISSIONS }
    else
      ret = { errCode: 1 }
    end
  end

  def add

    company_id = params[:company_id]
    title      = params[:title]
    job_type   = params[:job_type]
    info       = params[:info]
    skills     = params[:skills]
    tags       = params[:tags]

    company    = Company.find_by(company_name: current_user.company_name)
    ret = validate_user_company(company)

    if ret[:errCode] == 1          
      if company.company_id != company_id
        ret = {errCode: Jobposting.ERR_BAD_COMPANY_ID}
      else
        ret = Jobposting.add(company_id, title, job_type, info, skills, tags)
      end
    end
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
    ret = Jobposting.ranked_search(query)
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
