require 'jammit/command_line'
require 'jammit/s3_command_line'
require 'jammit/s3_uploader'

module Jammit
  def self.upload_to_s3!(options = {})
    S3Uploader.new(options).upload
  end
end
