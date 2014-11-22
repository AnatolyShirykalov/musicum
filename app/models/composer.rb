class Composer
  include Mongoid::Document
  include Mongoid::Paperclip

  has_mongoid_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_many :pieces
  belongs_to :city
  field :name, type: String
  field :co_url, type: String
  field :birthday, type: Date
  field :deathday, type: Date
end
