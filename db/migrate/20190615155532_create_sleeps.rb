class CreateSleeps < ActiveRecord::Migration[5.2]
  def change
    create_table :sleeps do |t|
      t.references :user
      t.uuid :uuid, null: false
      t.datetime :slept_at, null: false
      t.datetime :waked_at, null: false
      t.integer :duration

      t.timestamps
    end
    add_index :sleeps, :uuid, unique: true
  end
end
