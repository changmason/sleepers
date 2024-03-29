class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.integer :follower_id
      t.integer :following_id

      t.timestamps
    end
    add_index :friendships, [:follower_id, :following_id], unique: true
    add_index :friendships, [:following_id, :follower_id], unique: true
  end
end
