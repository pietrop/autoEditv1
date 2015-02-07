class AddUserRefToTranscripts < ActiveRecord::Migration
  def change
    add_reference :transcripts, :user, index: true
  end
end
