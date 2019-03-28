class CreateLogEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :log_entries do |t|
      t.timestamps
      t.string :topic
      t.string :entry_type
      t.integer :user_id
      t.string :user_email
      t.string :user_name
      t.integer :object_id
      t.string :object_type
      t.string :description
      t.boolean :loomio_consumed, default: false
    end
  end
end
