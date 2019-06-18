json.status 'ok'
json.type 'Sleep'
json.record do
  json.partial! @sleep, as: :record
end