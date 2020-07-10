class AddRateToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :rate, :float
  end
end
