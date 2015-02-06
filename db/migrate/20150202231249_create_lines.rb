class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :tc_in
      t.string :tc_out
      t.text :text
      t.integer :n
      t.text :note
      t.string :tag
      t.references :transcript, index: true

      t.timestamps
    end
  end
end
