class AddPricesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :preco_venda, :decimal
    add_column :users, :preco_compra, :decimal
  end
end
