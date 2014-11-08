require 'rails_helper'

RSpec.describe Event, :type => :model do
	#pending "add some examples to (or delete) #{__FILE__}"
	#test create event method
	it "should create an event given correct inputs" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err1 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		err2 = Event.create_event("", "Birthday", "info-session", "", test_time)
		expect(Event.count).to eq 2
		expect(err1[:errCode]).to eq Event::SUCCESS
		expect(err2[:errCode]).to eq Event::SUCCESS
	end


	#test create bad event title
	it "should fail given a bad title" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err1 = Event.create_event("Google", "", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		bad_title = "abbadabba"*100
		err2 = Event.create_event("Google", bad_title, "info-session", "Come to Soda 651 for infinite donuts", test_time)
		expect(err1[:errCode]).to eq Event::ERR_BAD_TITLE
		expect(err2[:errCode]).to eq Event::ERR_BAD_TITLE
	end

	#test create bad event type
	it "should fail given an invalid event type" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err1 = Event.create_event("Google", "Free Donuts", "", "Come to Soda 651 for infinite donuts", test_time)
		err2 = Event.create_event("Google", "Free Donuts", "bad-type", "Come to Soda 651 for infinite donuts", test_time)
		expect(err1[:errCode]).to eq Event::ERR_BAD_TYPE
		expect(err2[:errCode]).to eq Event::ERR_BAD_TYPE
	end

	#test create bad info
	it "should fail given bad info" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		bad_info = "infinite donuts"*(128*128)
		err1 = Event.create_event("Google", "Free Donuts", "info-session", bad_info, test_time)
		expect(err1[:errCode]).to eq Event::ERR_BAD_INFO
	end

	#test create bad date
	it "should fail given a bad date" do
		bad_time = DateTime.new(2000, 10, 31, 2, 30, 0, "-08:00")
		err1 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", bad_time)
		expect(err1[:errCode]).to eq Event::ERR_BAD_DATE 
	end

	#test create unique ids
	it "should create unique ids for events" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err1 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		err2 = Event.create_event("Apple", "Free Apples", "info-session", "Come to Soda 651 for free apples", test_time)

		event1 = Event.find_by(event_title: "Free Donuts")
		event2 = Event.find_by(event_title: "Free Apples")

		expect(event1.event_id).not_to eq event2.event_id
	end

	#test edit event
	it "should edit events with valid fields and values" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err0 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		event_id = Event.last()
		err1 = Event.edit_event(event_id, "title", "New Title")
		expect(err1[:errCode]).to eq Event::SUCCESS
	end

	#test delte bad event
	it "should fail given a nonexistant event_id" do
		err1 = Event.edit_event(-1, "title", "foo")
		expect(err1[:errCode]).to eq Event::ERR_NO_SUCH_EVENT
	end

	#test bad field
	it "should fail given and invalid field" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err0 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		event_id = Event.last().event_id
		err1 = Event.edit_event(event_id, "invalid", "foo")
		expect(err1[:errCode]).to eq Event::ERR_BAD_FIELD
	end

	#test bad value - only tests title for now
	it "should fail given and invalid value" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err0 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		event_id = Event.last().event_id
		bad_title = "donuts"*100
		err1 = Event.edit_event(event_id, "title", bad_title)
		expect(err1[:errCode]).to eq Event::ERR_BAD_TITLE
	end

	#test delete event
	it "should remove the specified event" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err0 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		event_id = Event.last().event_id
		err1 = Event.delete_event(event_id)
		expect(err1[:errCode]).to eq Event::SUCCESS
	end

	#test delete bad event
	it "should fail given a nonexistant event_id" do
		err1 = Event.delete_event(-1)
		expect(err1[:errCode]).to eq Event::ERR_NO_SUCH_EVENT
	end

	#test get event
	it "should succesffully retrieve an event" do
		test_time = DateTime.new(2020, 10, 31, 2, 30, 0, "-08:00")
		err0 = Event.create_event("Google", "Free Donuts", "info-session", "Come to Soda 651 for infinite donuts", test_time)
		event_id = Event.last().event_id
		err1, val1 = Event.get_event(event_id)
		expect(err1[:errCode]).to eq Event::SUCCESS
	end

	#test get bad event
	it "should fail given an nonexistant event_id" do
		err1, val1 = Event.get_event(-1)
		expect(err1[:errCode]).to eq Event::ERR_NO_SUCH_EVENT
	end
end
