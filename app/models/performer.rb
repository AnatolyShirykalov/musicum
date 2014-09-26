class Performer
  include Mongoid::Document
  has_many :pairs
  field :name, type: String
  #has_many :groups, through: :pairs
  #has_many :performs, through: :groups
  #has_many :instruments, through: :pairs
  belongs_to :city
end
