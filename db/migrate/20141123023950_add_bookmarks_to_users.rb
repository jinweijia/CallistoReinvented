class AddBookmarksToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bookmarks, :string
  end
end
