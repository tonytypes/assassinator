class MigrationToCreatePlayRelationship < ActiveRecord::Migration
  def up
  	add_column :plays, :game_id, :integer
  	add_column :plays, :userone_id, :integer
  	add_column :plays, :usertwo_id, :integer
  	add_column :plays, :useronestatus, :integer
  	add_index :plays, :game_id
  	add_index :plays, :userone_id
  	add_index :plays, :usertwo_id
  	add_index :plays, [:game_id, :userone_id, :usertwo_id], unique: true
  end

  def down
  end
end
