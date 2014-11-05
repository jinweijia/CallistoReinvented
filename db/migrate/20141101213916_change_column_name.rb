class ChangeColumnName < ActiveRecord::Migration
  def change
  	rename_column :users, :company_id, :company_name
  end
end
