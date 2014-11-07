class Event < ActiveRecord::Base
	
SUCCESS = 1
ERR_NO_SUCH_EVENT = -1
ERR_BAD_PERMISSIONS = -2
ERR_BAD_COMPANY = -3
ERR_BAD_TITLE = -4
ERR_BAD_TYPE = -5
ERR_BAD_INFO = -6
ERR_BAD_DATE = -7
ERR_BAD_FIELD = -8
MAX_TITLE_LENGTH = 128
MAX_INFO_LENGTH = 128*128
#this can be changed later, or any event type can be allowed
ALLOWED_TYPES = ['info-session', 'career fair', 'Q&A']
ALLOWED_FIELDS = ['title', 'type', 'info', 'date']

	#TODO: ownership
	#TODO: event ID generation
	#TODO: proper date validation?
	def create_event(company_id, title, type, info="", date)
		current_date = Time.now
		#verify title
		if title == "" or title.length > MAX_TITLE_LENGTH
			return {errCode: ERR_BAD_TITLE}
		#verify type
		elsif not ALLOWED_TYPES.include?(type)
			return {errCode: ERR_BAD_TYPE}
		#verify info
		elsif info.length > MAX_INFO_LENGTH
			return {errCode: ERR_BAD_INFO}
		#verify date
		elsif current_date > date
			return {errCode: ERR_BAD_DATE}
		else
			event = Event.new(event_id: 0, company_id: company_id, title: tile, type: type, info: info, date: date)
			event.save
			return {errCode: SUCCESS}
		end
	end

	#TODO: ownership
	#TODO: proper date validation?
	def edit_event(event_id, field, value)
		if not Event.exists?(event_id: event_id)
			return {errCode: ERR_NO_SUCH_EVENT}
		end

		event = Event.find_by(event_id: event_id)

		if not ALLOWED_FIELDS.include?(field)
			return {errCode: ERR_BAD_FIELD}
		end

		if field == 'title'
			if value == "" or value.length > MAX_TITLE_LENGTH
				return {errCode: ERR_BAD_TITLE}
			else
				event.update(title: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'type'
			if not ALLOWED_TYPES.include?(value)
				return {errCode: ERR_BAD_TYPE}
			else
				event.update(type: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'info'
			if info.length > MAX_INFO_LENGTH
				return {errCode: ERR_BAD_INFO}
			else
				event.update(info: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'date'
			current_date = Time.now
			if current_date > value
				return {errCode: ERR_BAD_DATE}
			else
				event.update(date: value)
				return {errCode: SUCCESS}
			end
		end
	end

	#TODO: ownership
	def delete_event(event_id)
		if not Event.exists?(event_id: event_id)
			return {errCode: ERR_NO_SUCH_EVENT}
		end

		event = Event.find_by(event_id: event_id)
		event.destroy
		return {errCode: SUCCESS}
	end

	def get_event(event_id)
		if not Event.exists?(event_id: event_id)
			return {errCode: ERR_NO_SUCH_EVENT}
		end

		event = Event.find_by(event_id: event_id)
		return {errCode: SUCCESS, value: event}
	end
end
