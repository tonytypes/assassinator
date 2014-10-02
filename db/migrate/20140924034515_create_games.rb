class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :gamename
      t.datetime :start
      t.datetime :end
      t.text :description
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
