class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.bigint :calendar_id, null: false
      t.string :title, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.integer :attendees_number, null: false

      t.string :status, null: false

      t.timestamps
    end
  end
end
