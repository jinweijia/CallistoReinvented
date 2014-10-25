require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe CompaniesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Company. As you add validations to Company, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {company_name: "A", company_info: ""}
  }

  let(:invalid_attributes) {
    {company_name: "", company_info: ""}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CompaniesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all companies as @companies" do
      company = Company.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:companies)).to eq([company])
    end
  end

  describe "GET show" do
    it "assigns the requested company as @company" do
      company = Company.create! valid_attributes
      get :show, {:id => company.to_param}, valid_session
      expect(assigns(:company)).to eq(company)
    end
  end

  describe "GET new" do
    it "assigns a new company as @company" do
      get :new, {}, valid_session
      expect(assigns(:company)).to be_a_new(Company)
    end
  end

  describe "GET edit" do
    it "assigns the requested company as @company" do
      company = Company.create! valid_attributes
      get :edit, {:id => company.to_param}, valid_session
      expect(assigns(:company)).to eq(company)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Company" do
        expect {
          post :create, {:company => valid_attributes}, valid_session
        }.to change(Company, :count).by(1)
      end

      it "assigns a newly created company as @company" do
        post :create, {:company => valid_attributes}, valid_session
        expect(assigns(:company)).to be_a(Company)
        expect(assigns(:company)).to be_persisted
      end

      it "redirects to the created company" do
        post :create, {:company => valid_attributes}, valid_session
        expect(response).to redirect_to(Company.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved company as @company" do
        post :create, {:company => invalid_attributes}, valid_session
        expect(assigns(:company)).to be_a_new(Company)
      end

      it "re-renders the 'new' template" do
        post :create, {:company => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested company" do
  #       company = Company.create! valid_attributes
  #       put :update, {:id => company.to_param, :company => new_attributes}, valid_session
  #       company.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested company as @company" do
  #       company = Company.create! valid_attributes
  #       put :update, {:id => company.to_param, :company => valid_attributes}, valid_session
  #       expect(assigns(:company)).to eq(company)
  #     end

  #     it "redirects to the company" do
  #       company = Company.create! valid_attributes
  #       put :update, {:id => company.to_param, :company => valid_attributes}, valid_session
  #       expect(response).to redirect_to(company)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the company as @company" do
  #       company = Company.create! valid_attributes
  #       put :update, {:id => company.to_param, :company => invalid_attributes}, valid_session
  #       expect(assigns(:company)).to eq(company)
  #     end

  #     it "re-renders the 'edit' template" do
  #       company = Company.create! valid_attributes
  #       put :update, {:id => company.to_param, :company => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   it "destroys the requested company" do
  #     company = Company.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => company.to_param}, valid_session
  #     }.to change(Company, :count).by(-1)
  #   end

  #   it "redirects to the companies list" do
  #     company = Company.create! valid_attributes
  #     delete :destroy, {:id => company.to_param}, valid_session
  #     expect(response).to redirect_to(companies_url)
  #   end
  # end

end
