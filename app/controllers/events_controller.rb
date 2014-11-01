class EventsController < ApplicationController

	#TODO: render json
	def create_event
		company_id = params[:company_id]
		title = params[:title]
		type = params[:type]
		info = params[:info]
		date = params[:date]
		result = Event.create_event(company_id, title, type, info, date)
	end

	#TODO: render json
	def edit_event
		event_id = params[:event_id]
		field = params[:field]
		value = params[:value]
		result = Event.edit_event(event_id, field, value)
	end

	#TODO: render json
	def delete_event
		event_id = params[:event_id]
		result = Event.delete_event(event_id)
	end

	#TODO: render json
	def get_event
		event_id = params[:event_id]
		result = Event.get_event[event_id]
	end
end