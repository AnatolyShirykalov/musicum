class Group
  include Mongoid::Document
  has_and_belongs_to_many :pairs
  has_many :performs
  #has_many :pieces, through: :performs
end