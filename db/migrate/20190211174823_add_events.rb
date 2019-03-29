class AddEvents < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.timestamps
    end

    create_table :events do |t|
      t.belongs_to :organization
      t.string :name
      t.string :slug
      t.datetime :submission_deadline
      t.datetime :safety_deadline
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps
    end

    add_index :events, :slug, unique: true

    add_column :memberships, :collective_type, :string, default: "Camp"
    rename_column :memberships, :camp_id, :collective_id
  end
end
