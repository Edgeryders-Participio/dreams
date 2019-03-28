class CreateSafetySketches < ActiveRecord::Migration[5.0]
  def change
    create_table :safety_sketches do |t|
      t.column :user_id, :integer
      t.column :camp_id, :integer
      t.timestamps
    end
  add_attachment :safety_sketches, :attachment, :after => :camp_id
  end
end