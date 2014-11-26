class Concert
  include Mongoid::Document
  belongs_to :hall
  validates :url, uniqueness: true
  validates :date, presence: true
  field :date, type: Date
  field :url, type: String
end
