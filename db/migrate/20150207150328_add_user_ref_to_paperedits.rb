class AddUserRefToPaperedits < ActiveRecord::Migration
  def change
    add_reference :paperedits, :user, index: true
  end
end
