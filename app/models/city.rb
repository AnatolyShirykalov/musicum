class City
  include Mongoid::Document
  belongs_to :country
  field :name, type: String
  has_many :halls
  has_many :composers
  has_many :performers
end
