class AddTagstoJobpostings < ActiveRecord::Migration
  def change
  	add_column :jobpostings, :skills, :string
  	add_column :jobpostings, :tags, :string
  end
end
