json.array!(@lines) do |line|
  json.extract! line, :id, :tc_in, :tc_out, :text, :n, :note, :tag, :transcript_id
  json.url line_url(line, format: :json)
end
