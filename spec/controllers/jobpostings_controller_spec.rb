require 'rails_helper'

RSpec.describe JobpostingController, :type => :controller do
  let(:valid_attributes_c) {
    {company_name: "Test", company_info: ""}
  }
  let(:invalid_attributes_c) {
    {company_name: "", company_info: ""}
  }
  let(:valid_attributes_p) {
    {title: "test_title", job_type: "internship", info: "test_info", skills: "test_skill", tags: "test_tag"}
  }
  let(:invalid_attributes_p) {
    {title: "test_title", job_type: "invalid_type", info: "test_info", skills: "test_skill", tags: "test_tag"}
  }
  let(:valid_session) { {} }

  # Code to make devise user authentication work  
  def sign_in(user = double('user'))
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      # allow(controller).to receive(:user_signed_in).and_return(user_signed_in)
    end
  end

  describe "POST add" do
    describe "with valid params" do
      it "creates a new Job Posting" do
        @request.env["devise.mapping"] = Devise.mappings[:user]    
        user = User.create(email: "testabcd@mail.com", password: 12345678, type: "Employer")
        sign_in user
        ret = Company.add("Test", "")
        # user.company_name does not get updated automatically
        user.update(company_name: "Test")
        expect {
          post :add, {title: "test_title", job_type: "internship", info: "test_info", skills: "test_skill", tags: "test_tag"}, valid_session
        }.to change(Jobposting, :count).by(1)
        sign_out user
      end
    end

    describe "with valid params" do
      it "creates a new Job Posting" do
        @request.env["devise.mapping"] = Devise.mappings[:user]    
        user = User.create(email: "testabcd@mail.com", password: 12345678, type: "Employer")
        sign_in user
        ret = Company.add("Test", "")
        # user.company_name does not get updated automatically
        user.update(company_name: "Test")
        expect {
          post :add, {title: "test_title", job_type: "invalid_type", info: "test_info", skills: "test_skill", tags: "test_tag"}, valid_session
        }.not_to change(Jobposting, :count)
        sign_out user
      end
    end
  end

end
