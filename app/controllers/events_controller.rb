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
    @event = result[:value]
    #render json: result
    render template: "events/post"
  end

  def index
    @events = Event.all
  end

  def show
    #respond_with(@event)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def search
    query = params[:q]
    ret = Event.simple_search(query)
    @event = ret[:value]
    render template: "events/show"
  end

  def create
    @event = Event.new(event_params)
    @event.save
    #event = params[:event]
    #event_company = event[:event_company]
    #event_title = event[:event_title]
    #event_type = event[:event_type]
    #event_info = event[:event_info]
    #event_date = DateTime.new( event["event_date(1i)"].to_i, event["event_date(2i)"].to_i, event["event_date(3i)"].to_i, event["event_date(4i)"].to_i, event["event_date(5i)"].to_i)

    #result = Event.create_event(event_company, event_title, event_type, event_info, event_date)
    #@event = Event.find_by(event_id: result[:event_id])
    #render json: result
    #@event = Event.new(event_params)
    #@event.save
    render template: "events/show"
  end

  def update
    @event.update(event_params)
    respond_with(@event)
  end

  def destroy
    @event.destroy
    #respond_with(@event)
    render template: "events/index"
  end

  private
    #def set_event
    #  @event = Event.find(params[:id])
    #end

    def event_params
      params.require(:event).permit(:event_id, :event_ownership, :event_company, :event_title, :event_type, :event_info, :event_date)
    end
end
