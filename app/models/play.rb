class Play < ActiveRecord::Base
  attr_accessible :useronekillcode, :game_id, :userone_id, :targetuser_id, :useronestatus
	validates_uniqueness_of :userone_id, :scope => [:game_id]

  # Adds Userone to Plays
  belongs_to :user, class_name: "User", foreign_key: "userone_id"
  
  # Add Targetuser to Plays
  belongs_to :targetted, class_name: "User", foreign_key: "targetuser_id"

  belongs_to :game, class_name: "Game", foreign_key: "game_id"
  validates :userone_id, presence: true
#  validates :targetuser_id, presence: true

end
