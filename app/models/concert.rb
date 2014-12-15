class Concert
  include Mongoid::Document
  belongs_to :hall
  validates :url, uniqueness: true
  validates :date, presence: true
  field :date, type: Date
  field :url, type: String
  field :desc, type: String
  field :prog, type: String
  def valid(conditions={})
    return true if conditions=={}
    return false if conditions[:since] and conditions[:since]> self[:date]
    return false if conditions[:til] and conditions[:til] < self[:date]
    suff = conditions[:sufficient]
    if suff and suff.class==Array
      suff.each do |word|
	return true if (self[:desc] and self[:desc].match(word)) or (self[:prog] and self[:prog].match(word))
      end
    end
    false
  end
end
