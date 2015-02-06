class CreatePaperedits < ActiveRecord::Migration
  def change
    create_table :paperedits do |t|
      t.string :projectname

      t.timestamps
    end
  end
end
