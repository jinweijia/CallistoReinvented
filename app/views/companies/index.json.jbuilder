json.array!(@companies) do |company|
  json.extract! company, :id, :company_id, :company_name, :company_info
  json.url company_url(company, format: :json)
end
