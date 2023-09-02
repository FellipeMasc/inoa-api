class AddNameToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :ativos, :string, null:false 
  end
end
