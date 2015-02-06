class Transcript < ActiveRecord::Migration
  def change
  	create_table :transcripts do |t|
      t.string :filename
      t.string :name
      t.string :speakername
      t.string :date
      t.string :youtubeurl
      t.string :reel
      t.string :tc_meta

      t.timestamps
  end
end
end
