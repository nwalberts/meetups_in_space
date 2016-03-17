class CreateEvent < ActiveRecord::Migration
  def change
    create_table :events do |table|
      table.integer :user_id, null: false
      table.integer :meetup_id, null: false
      table.boolean :creator, null: false, default: false

      table.timestamps null: false
    end
  end
end
