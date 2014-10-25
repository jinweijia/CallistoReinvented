class CreateJobpostings < ActiveRecord::Migration
  def change
    create_table :jobpostings do |t|
      t.integer :posting_id
      t.string :title
      t.string :company_name
      t.integer :company_id
      t.string :job_type
      t.string :info

      t.timestamps
    end
  end
end
