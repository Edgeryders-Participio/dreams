class CreateGrantWallets < ActiveRecord::Migration[5.0]
  def change
    create_table :grant_wallets do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :grants_left

      t.timestamps
    end
  end
end
