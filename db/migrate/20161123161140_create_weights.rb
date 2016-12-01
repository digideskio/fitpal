class CreateWeights < ActiveRecord::Migration[5.0]
  def change
    create_table :weights do |t|
      t.integer :weight
      t.date :date

      t.timestamps
    end
  end
end
