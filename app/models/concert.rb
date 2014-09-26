class Concert
  include Mongoid::Document
  belongs_to :hall
end
