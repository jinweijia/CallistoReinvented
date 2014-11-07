class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  
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

  def index
    @events = Event.all
    respond_with(@events)
  end

  def show
    respond_with(@event)
  end

  def new
    @event = Event.new
    respond_with(@event)
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with(@event)
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    respond_with(@event)
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:event_id, :event_ownership, :event_company, :event_title, :event_type, :event_info, :event_date)
    end
end
