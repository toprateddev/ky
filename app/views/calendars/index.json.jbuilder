json.array!(@calendars) do |calendar|
  json.extract! calendar, 
  json.url calendar_url(calendar, format: :json)
end
