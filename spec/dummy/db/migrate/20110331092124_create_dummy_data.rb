class CreateDummyData < ActiveRecord::Migration
  def self.up
    create_table :dummy_data do |t|
      t.string :trailed_field
      t.string :untrailed_field

      t.timestamps
    end
  end

  def self.down
    drop_table :dummy_data
  end
end
