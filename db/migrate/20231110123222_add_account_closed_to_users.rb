class AddAccountClosedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :account_closed, :boolean, default: false
  end
end
