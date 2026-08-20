class PermitPdfUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  CarrierWave.configure do |config|
    config.cache_storage = :file
  end

 def extension_allowlist
  %w[pdf xls xlsx]
end

  def size_range
    1..50.megabytes
  end

  process tags: ['jpermit_pdf']

  version :thumbnail do
    process convert: 'jpg'
    process resize_to_fit: [200, 200]
    process eager: true
  end

  def thumbnail_url
    return unless file

    Cloudinary::Utils.cloudinary_url(
      file.public_id,
      resource_type: "image",
      format: "jpg",
      page: 1,
      width: 200,
      height: 200,
      crop: :fit
    )
  end
end