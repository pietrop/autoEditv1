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
      self.lines.create!(tc_in: "0"+tc_in, tc_out: "0"+tc_out, text: text_chunks.join(' '), n: n)
      text_chunks = []
      state = :timecodes
    else
      text_chunks << line
    end
  end
end


end#end of method


def read_srt_file(srt_file)
text=" "
tc_in= " "
tc_out = " "
n=0
# puts srt_file.class.inspect
 srt_file.read.split("\r\n").each do |l|
  
  # if line is number  ie 1
  if l.match(/^[\d]*\r\n/)
    # save number
    # n = l.scan(/\d*/)[0]
    
  # elsif line is timecode ie "00:00:00,065 --> 00:00:03,162"
  elsif  l.match(/\d{2}:\d{2}:\d{2},\d{3} --> \d{2}:\d{2}:\d{2},\d{3}/)

    #this is to avoid aving a first line empty first time a round the loop
     
     self.lines.create!(tc_in: tc_in, tc_out: tc_out, text: text, n: n)
     n+=1
     text=" "
     tcs= l.split(/ --> /)
    tc_in = tcs[0].sub(",",".").split("\n")[0]
    tc_out = tcs[1].split(/\r\n/)[0].sub(",",".")
    elsif !l.empty?
      if !l.match(/^(\d)+$/)#it's not the line count,all digits
    speech = l.sub("\n"," ")
    text += speech
    end

else

end #else if

end#do loop
Transcript.last.lines.first.destroy
end#end of method srt


end#end of class
