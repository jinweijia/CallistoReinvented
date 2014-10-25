require 'rails_helper'

RSpec.describe "companies/edit", :type => :view do
  before(:each) do
    @company = assign(:company, Company.create!(
      :company_id => 1,
      :company_name => "MyString",
      :company_info => "MyString"
    ))
  end

  it "renders the edit company form" do
    render

    assert_select "form[action=?][method=?]", company_path(@company), "post" do

      assert_select "input#company_company_id[name=?]", "company[company_id]"

      assert_select "input#company_company_name[name=?]", "company[company_name]"

      assert_select "input#company_company_info[name=?]", "company[company_info]"
    end
  end
end
