class AddEventToCamps < ActiveRecord::Migration
  def change
    add_column :camps, :event_id, :integer, index: true
  end
end
