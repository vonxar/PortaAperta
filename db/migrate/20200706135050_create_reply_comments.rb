class CreateReplyComments < ActiveRecord::Migration[6.0]
  def change
    create_table :reply_comments do |t|
       t.integer :comment_id
       t.text :reply_comment
       t.integer :user_id

      t.timestamps
    end
  end
end
