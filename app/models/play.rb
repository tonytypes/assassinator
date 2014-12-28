class Play < ActiveRecord::Base
  attr_accessible :useronekillcode, :game_id, :userone_id, :targetuser_id
  attr_accessible :useronestatus, :kills
  attr_accessor :updatetargetkillcode, :updatekillcode, :targetkillcode
	validates_uniqueness_of :userone_id, :scope => [:game_id]

  # Adds Userone/Assassin to Plays
  belongs_to :assassin, class_name: "User", foreign_key: "userone_id"
  belongs_to :user, class_name: "User", foreign_key: "userone_id"
  # Removed 10/20 belongs_to :user, class_name: "User", foreign_key: "targetuser_id"

  # Add Target to Plays
  belongs_to :target, class_name: "User", foreign_key: "targetuser_id"

  # belongs_to :targets, class_name: "User"
  # belongs_to :targets, class_name: "User", foreign_key: "userone_id"
  # has_many :targets, class_name: "User", foreign_key: "targetuser_id"
  # has_many :targets, class_name: "User", foreign_key: "id"
  # has_many :assassins, class_name: "User", foreign_key: "id"

  belongs_to :game, class_name: "Game", foreign_key: "game_id"
  validates :userone_id, presence: true
#  validates :targetuser_id, presence: true
  
  validates :game_id, :presence => true, :on => :create
  validates :useronekillcode, :presence => true, :on => :create

  validates :useronekillcode, :presence => true, :on => :update, :if => :updatekillcode
  validates :targetkillcode, :presence => true, :on => :update, :if => :updatetargetkillcode

end
