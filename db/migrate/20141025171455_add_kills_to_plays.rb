class AddKillsToPlays < ActiveRecord::Migration
  def change
    add_column :plays, :kills, :integer
  end
end
