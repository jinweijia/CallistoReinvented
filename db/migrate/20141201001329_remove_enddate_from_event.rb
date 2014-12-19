class RemoveEnddateFromEvent < ActiveRecord::Migration
  def change
    remove_column :events, :end_date, :string
  end
end
