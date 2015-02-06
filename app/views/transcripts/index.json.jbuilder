json.array!(@transcripts) do |transcript|
  json.extract! transcript, :id, :filename, :speakername, :date, :youtubeurl, :reel, :tc_meta
  json.url transcript_url(transcript, format: :json)
end
