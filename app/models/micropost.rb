class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: Settings.maxcontent}
  validate :picture_size
  scope :by_userid, -> id {where user_id: id}
  scope :by_order, -> {order "microposts.created_at DESC"}
  
  private

  def picture_size
    if picture.size > (Settings.picturesize).megabytes
      errors.add :picture, t(".shouldbe")
    end
  end
end
