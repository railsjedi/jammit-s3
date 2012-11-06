require 'jammit/command_line'
require 'jammit/s3_command_line'
require 'jammit/s3_uploader'

module Jammit
  def self.upload_to_s3!(options = {})
    S3Uploader.new(options).upload
  end

  def self.cloudfront_configuration(env = nil)
    @cloudfront_configuration ||=
      begin
        rails_env = defined?(Rails) ? Rails.env : ENV['RAILS_ENV']
        cloudfront_config_path = File.join(ASSET_ROOT, 'config', 'cloudfront.yml')
        cloudfront_config = symbolize_keys(YAML.load(File.read(cloudfront_config_path))[rails_env])
      end
  end
end
