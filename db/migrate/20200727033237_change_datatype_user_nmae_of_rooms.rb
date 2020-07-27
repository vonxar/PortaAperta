class ChangeDatatypeUserNmaeOfRooms < ActiveRecord::Migration[6.0]
  def change
    change_column :rooms, :user_name, :text, array: true
  end
end
