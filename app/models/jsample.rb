class Jsample < ApplicationRecord
	 mount_uploader :video, VideoUploader


def self.ransackable_attributes(auth_object = nil)
    %w[bale_name]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


    # Validations
  validates :bale_name, presence: true
  validates :pieces_range, presence: true
  validates :price_range, presence: true
  #validates :video, presence: true
   validates :video_public_id, presence: true


     # Optional: generate URL helper
  def video_url
    return nil unless video_public_id.present?
    Cloudinary::Utils.cloudinary_url(video_public_id, resource_type: :video)
  end


end
