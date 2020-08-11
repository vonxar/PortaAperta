class AddUserToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :first_user_id, :int
    add_column :rooms, :second_user_id, :int
    add_column :rooms, :user_name, :string
  end
end
