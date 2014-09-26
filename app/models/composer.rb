class Composer
  include Mongoid::Document
  has_many :pieces
  belongs_to :city
  field :name, type: String
  field :birthday, type: Date
  field :deathday, type: Date
end
