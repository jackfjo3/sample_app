class Micropost < ActiveRecord::Base
  belongs_to :user
  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate 	:picture_size # note validate not validates for custom validation
private

	# Validates size of uploaded picture
	def picture_size
		if picture.size > 5.megabytes
			error.add(:picture, "should be less than 5 mb")
		end
	end

end
