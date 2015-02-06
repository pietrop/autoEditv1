class Line < ActiveRecord::Base
  require 'csv'
  belongs_to :transcript
  has_many :papercuts
  has_many :paperedits, through: :papercuts
  accepts_nested_attributes_for :papercuts

  def self.to_csv
  # raise "Kapow!!!"
  CSV.generate do |csv|
    csv << ["N","L", "Tc in","Tc out", "Speaker","Text", "Keywords", "Notes", "File name", "Filming date"]

    all.order("position asc").each do |line|
      csv << [line.papercuts.first.position,line.n, line.tc_in, line.tc_out, line.transcript.speakername, line.text, line.tag, line.note, line.transcript.filename, line.transcript.date ]
    end #closes loop
  end #closes csv
end # end of method self csv



end
