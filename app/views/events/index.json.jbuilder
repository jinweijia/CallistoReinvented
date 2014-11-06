json.array!(@events) do |event|
  json.extract! event, :id, :event_id, :event_ownership, :event_company, :event_title, :event_type, :event_info, :event_date
  json.url event_url(event, format: :json)
end
