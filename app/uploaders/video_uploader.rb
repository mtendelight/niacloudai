class VideoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  # Cloudinary handles everything server-side
  version :thumbnail do
    eager true
    cloudinary_transformation crop: :fill, width: 150, height: 150
  end

  version :large do
    eager true
    cloudinary_transformation crop: :limit, width: 500, height: 500
  end

  def extension_allowlist
    %w(mp4 mov avi mkv webm)
  end
end
