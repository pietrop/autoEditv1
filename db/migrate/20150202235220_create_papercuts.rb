class CreatePapercuts < ActiveRecord::Migration
  def change
    create_table :papercuts do |t|
      t.integer :position
      t.belongs_to :line, index: true
      t.belongs_to :paperedit, index: true
      t.string :comment

      t.timestamps
    end
  end
end
