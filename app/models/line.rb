class Line < ActiveRecord::Base
  require 'csv'
  belongs_to :transcript
  has_many :papercuts
  has_many :paperedits, through: :papercuts
  accepts_nested_attributes_for :papercuts, :paperedits


  def self.to_csv
  # raise "Kapow!!!"
  

  CSV.generate do |csv|
    csv << ["N","L", "Tc in","Tc out", "Speaker","Text", "Keywords", "Notes", "File name", "Reel","Filming date"]
    rec_in = Timecode.parse("00:00:00:00",fps = 25)
    all.order("position asc").each do |line|
      tc_meta = Timecode.parse(line.transcript.tc_meta, fps = 25)
      time_in = Timecode.parse_with_fractional_seconds(line.tc_in, fps = 25) 
      time_out = Timecode.parse_with_fractional_seconds(line.tc_out, fps = 25)
      rec_out =  time_out - time_in + rec_in
      csv << [line.papercuts.first.position,line.n, time_in , time_out , line.transcript.speakername, line.text, line.tag, line.note, line.transcript.filename,line.transcript.reel, line.transcript.date ]
    rec_in = rec_out
    end #closes loop
  end #closes csv
end # end of method self csv


# def self.format_lines
#    all.order("position asc").each do |line|
#     "hello world"
#   end
# end 


# def self.to_text
#   all.order("position asc").each do |line|
#   end
# end

end

