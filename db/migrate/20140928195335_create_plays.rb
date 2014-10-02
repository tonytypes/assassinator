class CreatePlays < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.string :useronekillcode

      t.timestamps
    end
  end
end
