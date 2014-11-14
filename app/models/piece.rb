class Piece
  include Mongoid::Document
  has_many :performs
  #has_many :groups, through: :performs
  #has_many :pairs, through: :groups
  #has_many :performers, through: :pairs
  belongs_to :composer
  field :name, type: String
end
