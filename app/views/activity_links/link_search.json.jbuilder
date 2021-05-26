json.array! @activities do |activity|
  json.id activity.id
  json.name activity.name
  json.description activity.short_description
  json.author activity.user.username
end