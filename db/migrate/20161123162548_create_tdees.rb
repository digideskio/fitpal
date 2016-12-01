class CreateTdees < ActiveRecord::Migration[5.0]
  def change
    create_table :tdees do |t|
      t.integer :tdee
      t.date :date

      t.timestamps
    end
  end
end
