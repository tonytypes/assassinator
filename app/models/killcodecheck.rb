class Killcodecheck
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

	attr_accessor :targetkillcode, :game_id

#  validates :targetkillcode, :presence => {:on => :create}

	validates_presence_of :targetkillcode
  
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def persisted?
    false
  end

end
