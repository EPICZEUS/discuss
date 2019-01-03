class AddColumnsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_room, :integer
    add_column :users, :status, :string
  end
end
