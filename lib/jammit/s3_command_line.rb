require 's3'
module Jammit
  class S3CommandLine < CommandLine
    def initialize
      super
      ensure_s3_configuration

      begin
        Jammit.upload_to_s3!
      rescue S3::Error::BucketAlreadyExists => e
        # tell them to pick another name
        puts e.message
        exit(1)
      end
    end

    protected
      def ensure_s3_configuration
        bucket_name = Jammit.cloudfront_configuration[:s3_bucket]
        unless bucket_name.is_a?(String) && bucket_name.length > 0
          puts "\nA valid s3_bucket name is required."
          puts "Please add one to your Jammit config (config/assets.yml):\n\n"
          puts "s3_bucket: my-bucket-name\n\n"
          exit(1)
        end

        access_key_id = Jammit.cloudfront_configuration[:s3_access_key_id]
        unless access_key_id.is_a?(String) && access_key_id.length > 0
          puts "access_key_id: '#{access_key_id}' is not valid"
          exit(1)
        end

        secret_access_key = Jammit.cloudfront_configuration[:s3_secret_access_key]
        unless secret_access_key.is_a?(String) && secret_access_key.length > 0
          puts "secret_access_key: '#{secret_access_key}' is not valid"
          exit(1)
        end
      end

  end
end
