class Instrument
  include Mongoid::Document
  has_many :pairs
  field :name, type: String
  #has_many :performers, through: :pairs	
end
