json.status 'success'
json.type 'User'
json.record do
  json.id @following.id
  json.email @following.email
end