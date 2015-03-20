class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => :add

  ERR_BAD_PERMISSIONS = -4

  def profile
  end

  def add
    # hack for loading jobs for testing
    # REMOVE DURING ACTUAL RELEASE!!!
    # hack = params[:hack]
    # if hack == 1296
    #   name = params[:company_name]
    #   info = params[:company_info]
    #   err = Company.add(name, info)
    #   @company = Company.last()
    #   respond_to do |format|
    #     format.json { render json: { errCode: err, company: @company } }
    #     format.html { render template: "users/dashboard" }
    #   end
    #   return
    # end
    #Validates if the current user has permissions to add company
    if current_user.type != "Employer"
      render json: { errCode: ERR_BAD_PERMISSIONS }
    else
      # print "add company in progress"
      name = params[:company_name]
      info = params[:company_info]
      err = Company.add(name, info)
      if err == Company::SUCCESS
        @company = Company.last()
        current_user.update(company_name: @company.company_name)
        respond_to do |format|
          format.json { render json: { errCode: err, company: @company } }
          format.html { render template: "users/dashboard" }
        end
        # redirect_to '/companies'
      else
        render json: { errCode: err }
      end
    end    
  end

  def show
    # id = params[:id]
    # err, name, info = Company.get(id)
    # if err == Company::SUCCESS
    #   render template: "company/profile"
    #   #render json: { company_id: id, company_name: name, company_info: info }
    # else
    #   render json: { errCode: err }
    # end

    @company = Company.find(params[:id])

    respond_to do |format|
      format.html { render template: "users/dashboard" } # show.html.erb
      # render template: "company/profile"
      format.json  { render :json => @company }
    end

  end

  def resetFixture

    result = Company.resetFixture
    render json: { errCode: result }

  end

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
    # result = self.add()
    # # @company = result[:company]
    # format.html { redirect_to result[:company], notice: 'Company was successfully created.' }
    # format.json { render :show, status: :created, location: result[:company] }
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:company_id, :company_name, :company_info)
    end
end
