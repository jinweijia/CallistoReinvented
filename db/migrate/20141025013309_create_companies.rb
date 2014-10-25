class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :company_id
      t.string :company_name
      t.string :company_info

      t.timestamps
    end
  end
end
