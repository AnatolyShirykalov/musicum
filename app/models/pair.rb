class Pair
  include Mongoid::Document
  has_and_belongs_to_many :groups
  belongs_to :performer
  belongs_to :instrument
end
