class Hall
  include Mongoid::Document
  has_many :concerts
  field :name, type: String
  belongs_to :city
end
