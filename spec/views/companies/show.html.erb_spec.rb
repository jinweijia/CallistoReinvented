require 'rails_helper'

RSpec.describe "companies/show", :type => :view do
  before(:each) do
    @company = assign(:company, Company.create!(
      :company_id => 1,
      :company_name => "Company Name",
      :company_info => "Company Info"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Company Name/)
    expect(rendered).to match(/Company Info/)
  end
end
