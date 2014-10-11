class Game < ActiveRecord::Base
  attr_accessible :gamename, :start, :end, :status, :description
  validates :gamename, presence: true
  validates :gamename, uniqueness: { case_sensitive: false }
  has_many :plays, class_name: "Play", foreign_key: "game_id", :dependent => :destroy
  
  # Adds Users to Games (after adding user_id column to Games and indexing user_id col in Games)
  belongs_to :user
  validates :user_id, presence: true



end
