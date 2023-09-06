class AddJobIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :job_id, :string
  end
end
