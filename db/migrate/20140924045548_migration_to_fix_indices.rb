class MigrationToFixIndices < ActiveRecord::Migration
  def up
  	remove_index :game_plays, [:userone_id, :usertwo_id]
  	add_index :game_plays, :userone_id
  	add_index :game_plays, :usertwo_id
  	add_index :game_plays, [:userone_id, :usertwo_id], unique: true
  end

  def down
  end
end
