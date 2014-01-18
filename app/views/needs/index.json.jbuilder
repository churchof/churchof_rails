json.array!(@needs) do |need|
  json.extract! need, :id, :title, :description
  json.url need_url(need, format: :json)
end
