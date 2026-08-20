
module JSON
  module_function

  def parse(source, opts = {})
    Parser.new(source).parse # remove opts to avoid passing a second argument
  end
end

version_file_path = "#{__dir__}/../../package.json"
if File.exist?(version_file_path)
  json_content = File.read(version_file_path)
  package_info = JSON.parse(json_content)
  version = package_info['version'] if package_info
else
  # Handle case when file doesn't exist or can't be read
  version = 'Unknown'
  Rails.logger.error "Failed to read package.json file at #{version_file_path}"
end
