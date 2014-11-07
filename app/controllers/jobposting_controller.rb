class JobpostingController < ApplicationController
  before_action :set_jobposting, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :add

  def add
    company_name = current_user.company_name
    company      = Company.find_by(company_name: company_name)
    if company == nil
        ret = {errCode: Jobposting.ERR_BAD_COMPANY_ID}
    else
        company_id = params[:company_id]
        title      = params[:title]
        job_type   = params[:job_type]
        info       = params[:info]
        skills       = params[:skills]
        tags       = params[:tags]
        if company.company_id != company_id
            ret = {errCode: Jobposting.ERR_BAD_COMPANY_ID}
        else
            ret        = Jobposting.add(company_id, title, job_type, info, skills, tags)
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

  def delete
    # !Need to validate user permissions here
    company_id = params[:company_id]
    posting_id = params[:posting_id]
    ret = Jobposting.remove(posting_id, company_id)
    render json: ret
  end

end
