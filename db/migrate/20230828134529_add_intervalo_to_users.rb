class AddIntervaloToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :intervalo_checagem, :string, null:false
  end
end
