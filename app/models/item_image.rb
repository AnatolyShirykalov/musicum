class ItemImage
  include Mongoid::Document
  mount_uploader :data, AvatarUploader
end
