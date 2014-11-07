class AddTagsToUser < ActiveRecord::Migration
  def change
    add_column :users, :saved_tags, :string
  end
end
