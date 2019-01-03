class AddColumnToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :likes, :integer, default: 0, null: false
  end
end
