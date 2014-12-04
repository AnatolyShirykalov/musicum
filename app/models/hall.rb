class Hall
  include Mongoid::Document
  include Mongoid::Paperclip
  has_many :concerts
  validates :name, uniqueness: true, presence: true,
		   length: {minimum: 5}
  has_mongoid_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] 
  field :name, type: String
  field :url, type: String
  belongs_to :city
end
