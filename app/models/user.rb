class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         # Temporarily removed ability to recover password
         # via email. That link no longer appears on any pages
         #:recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :firstname, :lastname
  # attr_accessible :title, :body
  # Adds Games to Users
  has_many :games, :dependent => :destroy
  # Adds Plays to Users
  has_many :plays, class_name: "Play", foreign_key: "userone_id", :dependent => :destroy
  # Adds Plays to Users for targets
  has_many :plays, class_name: "Play", foreign_key: "targetuser_id", :dependent => :destroy
  # Adds user's relationship to his/her targets
  has_many :targetted_users, through: :plays, source: :targetted

end
