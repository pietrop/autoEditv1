class Transcript < ActiveRecord::Base
	has_many :lines, dependent: :destroy
  belongs_to :user




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
      self.lines.create!(tc_in: tc_in, tc_out: tc_out, text: text_chunks.join(' '), n: n)
      text_chunks = []
      state = :timecodes
    else
      text_chunks << line
    end
  end
end


end
end
