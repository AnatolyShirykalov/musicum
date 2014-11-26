class Condition
  include Mongoid::Document
  has_many :sufficients
  field :f_date, type: Date
  field :t_date, type: Date
  accepts_nested_attributes_for :sufficients, allow_destroy: true
end
