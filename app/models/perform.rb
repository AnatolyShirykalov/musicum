class Perform
  include Mongoid::Document
  field :desc, type: String
  field :co_url, type: String
  belongs_to :piece
  belongs_to :group
  belongs_to :concert
end
