class RemoveUserTwoIdColumninPlay < ActiveRecord::Migration
  def up
		remove_index :plays, :usertwo_id
  	remove_index :plays, [:game_id, :userone_id, :usertwo_id]
  	remove_column :plays, :usertwo_id, :integer
  	add_column :plays, :targetuser_id, :integer
   	add_index :plays, :targetuser_id
  	add_index :plays, [:game_id, :userone_id, :targetuser_id], unique: true
  end

  def down
  end
end
