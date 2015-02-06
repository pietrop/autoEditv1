json.array!(@paperedits) do |paperedit|
  json.extract! paperedit, :id, :projectname
  json.url paperedit_url(paperedit, format: :json)
end
