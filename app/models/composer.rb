class Composer
  include Mongoid::Document
  include Mongoid::Paperclip

  #include ActiveModel::ForbiddenAttributesProtection
  #include Uploader::Composer
  #include Uploader::Fileuploads
  #fileuploads :avatars
  #accepts_nested_attributes_for :avatars
  has_mongoid_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  #field :avatar, type: String
  #field :avatar_secure_token, type: String
  #has_many :avatars, :class_name => "ItemImage", as: :assetable, dependent: :destroy
  #mount_uploader :avatar, ComposerUploader
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  has_many :pieces
  belongs_to :city
  field :name, type: String
  field :birthday, type: Date
  field :deathday, type: Date
end
