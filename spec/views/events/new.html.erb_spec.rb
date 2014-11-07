require 'rails_helper'

RSpec.describe "events/new", :type => :view do
  before(:each) do
    assign(:event, Event.new(
      :event_id => 1,
      :event_ownership => "MyString",
      :event_company => "MyString",
      :event_title => "MyString",
      :event_type => "MyString",
      :event_info => "MyText"
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input#event_event_id[name=?]", "event[event_id]"

      assert_select "input#event_event_ownership[name=?]", "event[event_ownership]"

      assert_select "input#event_event_company[name=?]", "event[event_company]"

      assert_select "input#event_event_title[name=?]", "event[event_title]"

      assert_select "input#event_event_type[name=?]", "event[event_type]"

      assert_select "textarea#event_event_info[name=?]", "event[event_info]"
    end
  end
end
