class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :event_id
      t.string :event_ownership
      t.string :event_company
      t.string :event_title
      t.string :event_type
      t.text :event_info
      t.datetime :event_date

      t.timestamps
    end
  end
end
