class AddLoomioThreadToCamp < ActiveRecord::Migration[5.0]
  def change
    change_table :camps do |t|
      t.string :loomio_thread_id
      t.string :loomio_thread_key
    end
  end
end
