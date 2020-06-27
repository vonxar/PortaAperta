class AddPorfilImageIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_image_id, :string
    add_column :users, :introduction, :text
  end
end
