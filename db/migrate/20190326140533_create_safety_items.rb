class CreateSafetyItems < ActiveRecord::Migration[5.0]
  def change
    create_table :safety_items do |t|
      t.string :headline
      t.string :information
      t.references :camp, foreign_key: true

      t.timestamps
    end
  end
end