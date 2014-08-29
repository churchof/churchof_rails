json.array!(@initiative_metrics) do |initiative_metric|
  json.extract! initiative_metric, :id
  json.url initiative_metric_url(initiative_metric, format: :json)
end
