json.status 'ok'
json.type 'Sleep'
json.record do
  json.uuid @sleep.uuid
  json.slept_at @sleep.slept_at.to_datetime.rfc3339
  json.waked_at @sleep.waked_at.to_datetime.rfc3339
  json.duration @sleep.duration
  json.created_at @sleep.created_at.to_datetime.rfc3339
end