class AddReplyUserIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reply_comment_id, :int
  end
end
