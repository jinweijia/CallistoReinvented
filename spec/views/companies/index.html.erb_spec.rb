require 'rails_helper'

RSpec.describe "companies/index", :type => :view do
  before(:each) do
    assign(:companies, [
      Company.create!(
        :company_id => 1,
        :company_name => "Company Name",
        :company_info => "Company Info"
      ),
      Company.create!(
        :company_id => 1,
        :company_name => "Company Name",
        :company_info => "Company Info"
      )
    ])
  end

  it "renders a list of companies" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Company Name".to_s, :count => 2
    assert_select "tr>td", :text => "Company Info".to_s, :count => 2
  end
end
