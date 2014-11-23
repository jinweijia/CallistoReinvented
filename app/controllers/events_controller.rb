class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token

  SUCCESS = 1
  ERR_BAD_PERMISSIONS = -1

  #def validate_user_company(company)
  #  if current_user.type != "Employer" || current_user.company_name != company.company_name
  #    toreturn = { errCode: ERR_BAD_PERMISSIONS }
  #  else
  #    toreturn = { errCode: SUCCESS }
  #  end
  #end
  
  #TODO: render json
  def create_event
    company_id = params[:company_id]
    title = params[:title]
    type = params[:type]
    info = params[:info]
    #this method expects a string in yy:mm:dd:hh:MM format, as one string with no spaces, where the hour is in range {00..23}
    #Example: "1401032307" would be January 3rd, 2014, at 23:07
    date = params[:date]
    datetime = DateTime.strptime(date, "%y%m%d%H%M")

    result = Event.create_event(company_id, title, type, info, datetime)
    render json: result
  end

  #TODO: render json
  def edit_event
    event_id = params[:event_id]
    field = params[:field]
    value = params[:value]

    if field == "date"
      value = DateTime.strptime(value, "%y%m%d%H%M")
    end

    result = Event.edit_event(event_id, field, value)
    render json: result
  end

  #TODO: render json
  def delete_event
    event_id = params[:id]
    result = Event.delete_event(event_id)
    render json: result
  end

  #TODO: render json
  def get_event
    event_id = params[:id]
    result = Event.get_event(event_id)
    render json: result
  end




  def index
    @events = Event.all
  end

  def show
    respond_with(@event)
  end

  def new
    @event = Event.new
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
