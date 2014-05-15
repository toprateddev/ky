json.array!(@events) do |event|
  json.title event.name
  json.start event.start.to_i
  json.end event.end.to_i
  json.allDay event.all_day? ? true : false
  json.url event_path event.parent_id.nil? ? event.id : event.parent_id
end
