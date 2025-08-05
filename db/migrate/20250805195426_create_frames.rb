class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.decimal :center_x
      t.decimal :center_y
      t.decimal :width
      t.decimal :height

      t.timestamps
    end
  end
end
