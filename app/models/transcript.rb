class Transcript < ActiveRecord::Base
  has_many :lines, dependent: :destroy
  belongs_to :user


validates :filename, :speakername, :date, :youtubeurl, :reel, :tc_meta, :name, :presence => true

# validates_attachment :sbv_file, :presence => true

def read_sbv_file(sbv_file)

n = 0
state = :timecodes
tc_in = tc_out = nil
text_chunks = []

#m = 1  #setting transcript number, transcript_id for the lines, to be grouped into transcripts
sbv_file.read.split("\n").each do |line|
  line.gsub!(/\n/, '')
  case state
  when :timecodes
    tc_in, tc_out = line.split(',')
    n += 1
    state = :text
  when :text
    if line.empty?
      self.lines.create!(tc_in: "0"+tc_in.gsub(/\s+/, ""), tc_out: "0"+tc_out.gsub(/\s+/, ""), text: text_chunks.join(' ').force_encoding('UTF-8'), n: n)
      text_chunks = []
      state = :timecodes
    else
      text_chunks << line
    end
  end
end


end#end of method


def read_srt_file(srt_file)

n=0
#uisng this gem srt https://github.com/cpetersen/srt
file = SRT::File.parse(srt_file.read)
  file.lines.each do |line|
   n= line.sequence
   tc_in= line.time_str.split(/ --> /)[0].sub(",",".").match(/\d{2}:\d{2}:\d{2}\.\d{3}/).to_s.gsub(/\s+/, "")
   tc_out= line.time_str.split(/ --> /)[1 ].sub(",",".").match(/\d{2}:\d{2}:\d{2}\.\d{3}/).to_s.gsub(/\s+/, "")
   # enforcing Encoding to UTF-8 coz otherwise when copy and pasting from word to make the srt, risk of ASCII compatibility issues.
   text= line.text.join(' ').force_encoding('UTF-8') #.text is an srt method and it returns an array
    self.lines.create!(tc_in: tc_in, tc_out: tc_out, text: text, n: n)
  end


end#end of method srt


end#end of class