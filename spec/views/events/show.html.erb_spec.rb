require 'rails_helper'

RSpec.describe "events/show", :type => :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :event_id => 1,
      :event_ownership => "Event Ownership",
      :event_company => "Event Company",
      :event_title => "Event Title",
      :event_type => "Event Type",
      :event_info => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Event Ownership/)
    expect(rendered).to match(/Event Company/)
    expect(rendered).to match(/Event Title/)
    expect(rendered).to match(/Event Type/)
    expect(rendered).to match(/MyText/)
  end
end
