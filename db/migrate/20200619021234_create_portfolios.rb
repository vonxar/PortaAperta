class CreatePortfolios < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolios do |t|
      t.integer :user_id
      t.string :image_id
      t.string :title
      t.text :body
      t.integer :category_id

      t.timestamps
    end
  end
end
