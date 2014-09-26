class Perform
  include Mongoid::Document
  belongs_to :piece
  belongs_to :group
  belongs_to :concert
end
