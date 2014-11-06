require 'rails_helper'

RSpec.describe "events/index", :type => :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :event_id => 1,
        :event_ownership => "Event Ownership",
        :event_company => "Event Company",
        :event_title => "Event Title",
        :event_type => "Event Type",
        :event_info => "MyText"
      ),
      Event.create!(
        :event_id => 1,
        :event_ownership => "Event Ownership",
        :event_company => "Event Company",
        :event_title => "Event Title",
        :event_type => "Event Type",
        :event_info => "MyText"
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Event Ownership".to_s, :count => 2
    assert_select "tr>td", :text => "Event Company".to_s, :count => 2
    assert_select "tr>td", :text => "Event Title".to_s, :count => 2
    assert_select "tr>td", :text => "Event Type".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
