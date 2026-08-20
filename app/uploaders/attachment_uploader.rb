class AttachmentUploader < CarrierWave::Uploader::Base

  include Cloudinary::CarrierWave

  def extension_allowlist
    %w[
      jpg jpeg png gif
      pdf
      doc docx
      xls xlsx
      mp4 mov
      zip
    ]
  end


  process tags: ['chat_attachment']


  version :thumb do
    process resize_to_fit: [200, 200]
  end


  def size_range
    1..50.megabytes
  end

end