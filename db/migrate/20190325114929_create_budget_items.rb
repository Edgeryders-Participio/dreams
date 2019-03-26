class CreateBudgetItems < ActiveRecord::Migration[5.0]
  def change
    create_table :budget_items do |t|
      t.string :description
      t.integer :amount
      t.references :camp, foreign_key: true

      t.timestamps
    end
  end
end
