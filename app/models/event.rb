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
#ALLOWED_TYPES = ['info-session', 'career fair', 'Q&A']
ALLOWED_FIELDS = ['title', 'type', 'info', 'date']
ALLOWED_TYPES = ['Info Session', 'Career Fair', 'Q&A']
	#TODO: ownership
	#TODO: event ID generation
	#TODO: proper date validation?
	def self.create_event(company_id, title, type, info, date)
		current_date = DateTime.now
		#verify title
		if title == "" or title.length > MAX_TITLE_LENGTH
			return {errCode: ERR_BAD_TITLE}
		#verify type
		elsif not ALLOWED_TYPES.include?(type)
			return {errCode: ERR_BAD_TYPE}
		#verify info
		elsif info.length > MAX_INFO_LENGTH
			return {errCode: ERR_BAD_INFO}
		#verify date - past dates are not allowed
		elsif current_date > date
			return {errCode: ERR_BAD_DATE}
		else
			last_event = Event.last()
			if last_event.blank?
				event_id = 1
			else
				if last_event.event_id.blank?
					event_id = 1
				else
					event_id = last_event.event_id + 1
				end
			end

			#event = Event.new(event_id: event_id, company_id: company, title: title, type: type, info: info, date: date)
			event = Event.new(event_id: event_id, event_ownership: "", event_company: company_id, event_title: title, event_type: type, event_info: info, event_date: date)
			event.save
			return {errCode: SUCCESS, event_id: event_id}
		end
	end

	#TODO: ownership
	#TODO: proper date validation?
	def self.edit_event(event_id, field, value)
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
				event.update(event_title: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'type'
			if not ALLOWED_TYPES.include?(value)
				return {errCode: ERR_BAD_TYPE}
			else
				event.update(event_type: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'info'
			if value.length > MAX_INFO_LENGTH
				return {errCode: ERR_BAD_INFO}
			else
				event.update(event_info: value)
				return {errCode: SUCCESS}
			end
		end

		if field == 'date'
			current_date = DateTime.now
			if current_date > value
				return {errCode: ERR_BAD_DATE}
			else
				event.update(event_date: value)
				return {errCode: SUCCESS}
			end
		end
	end

	#TODO: ownership
	def self.delete_event(event_id)
		if not Event.exists?(event_id: event_id)
			return {errCode: ERR_NO_SUCH_EVENT}
		end

		event = Event.find_by(event_id: event_id)
		event.destroy
		return {errCode: SUCCESS}
	end

	def self.get_event(event_id)
		if not Event.exists?(event_id: event_id)
			return {errCode: ERR_NO_SUCH_EVENT, value: nil}
		end

		event = Event.find_by(event_id: event_id)
		return {errCode: SUCCESS, value: event}
	end

	def self.simple_search(query)# do a fuzzy over all fields that are string types and see if any match occurs
    	q = "%"+query+"%"
    	posting = Event.where("event_title like ? OR event_company like ? OR event_type like ? OR event_info like ?", q, q, q, q).first
    	return {errCode: SUCCESS, value: posting}
	end
end
