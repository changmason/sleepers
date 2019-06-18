json.status 'ok'
json.type 'Sleep'
json.records do
  json.array! @sleeps, partial: 'sleep', as: :record
end