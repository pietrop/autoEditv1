json.array!(@papercuts) do |papercut|
  json.extract! papercut, :id, :position, :line_id, :paperedit_id, :comment
  json.url papercut_url(papercut, format: :json)
end
