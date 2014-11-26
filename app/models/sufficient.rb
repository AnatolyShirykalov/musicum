class Sufficient
  include Mongoid::Document
  belongs_to :condition
  field :desc, type: String
end
