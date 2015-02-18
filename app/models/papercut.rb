class Papercut < ActiveRecord::Base
  # has_and_belongs_to_many :lines
  # has_and_belongs_to_many :paperedit

  
  belongs_to :paperedit
   belongs_to :transcript
  belongs_to :line
  accepts_nested_attributes_for :line#

# default_scope order('created_at DESC')
  # default_scope order("created_at ASC")
  # belongs_to :lines
  # http://guides.rubyonrails.org/association_basics.html

#   def self.to_csv
#   # raise "Kapow!!!"
#   CSV.generate do |csv|
#     csv << ["N", "Tc in","Tc out", "Speaker","Text", "Keywords", "Notes", "File name", "Filming date"]

#     all.each do |papercut|
#       csv << [papercut.line.n, papercut.line.tc_in, papercut.line.tc_out, papercut.line.transcript.speakername, papercut.line.text, papercut.line.keyword, papercut.line.note, papercut.line.transcript.filename, papercut.line.transcript.date ]
#     end #closes loop
#   end #closes csv
# end # end of method self csv



end
