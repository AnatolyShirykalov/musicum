class Hall
  include Mongoid::Document
  has_many :concerts
  validates :name, uniqueness: true, presence: true,
		   length: {minimum: 5}
  field :name, type: String
  field :url, type: String
  belongs_to :city
end
