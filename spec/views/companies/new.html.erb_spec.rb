require 'rails_helper'

RSpec.describe "companies/new", :type => :view do
  before(:each) do
    assign(:company, Company.new(
      :company_id => 1,
      :company_name => "MyString",
      :company_info => "MyString"
    ))
  end

  it "renders new company form" do
    render

    assert_select "form[action=?][method=?]", companies_path, "post" do

      assert_select "input#company_company_id[name=?]", "company[company_id]"

      assert_select "input#company_company_name[name=?]", "company[company_name]"

      assert_select "input#company_company_info[name=?]", "company[company_info]"
    end
  end
end
