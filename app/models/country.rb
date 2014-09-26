class Country
  include Mongoid::Document
  has_many :cities
  field :name, type: String
end
