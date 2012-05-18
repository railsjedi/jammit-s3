# Jammit S3

## Introduction

Jammit S3 is a jammit wrapper that provides appropriate hooks so you can easily deploy your assets to s3/cloudfront

It's especially great for Heroku user who use generated assets such as coffee-script and sass. jammit-s3 includes a script you can use as a hook to recompile and upload all your assets.


## Installation

To install jammit-s3, just use:

    gem install jammit-s3

If you are using Rails3, add it to your project's `Gemfile`:

    gem 'jammit-s3'


Jammit S3 already has a gem dependency for jammit, so I'd recommend removing any existing `gem 'jammit'` references from your Gemfile.


## Configuration

Within your `config/assets.yml`, just add a toplevel key called `s3_bucket` that contains the bucketname you want to use. If jammit-s3 doesn't find the bucket, it will try to create it. Bucketnames need to be globally unique. Learn more about bucketnames [here](http://support.rightscale.com/06-FAQs/FAQ_0094_-_What_are_valid_S3_bucket_names%3F)

    s3_bucket: my-awesome-jammit-bucket

The package_path parameter can also be used to create a route folder in your S3 bucket.  This can be useful when pushing assets for different environments.
  
    package_path: <%= ENV['RAILS_ENV'] %>

## Deployment

To deploy your files to s3, just the jammit-s3 command at your project's root.

    jammit-s3

If using it in the context of your Rails3 app, I'd recommend using `bundle exec`

    bundle exec jammit-s3

## Saving Authentication Info

Set your authenticaton information within `config/assets.yml`

    s3_access_key_id: 03HDMNF59CWZ2J24T702
    s3_secret_access_key: 1TzRlDmuH8DoOlJ2tlwW8qx+i+Pfe0jzIouWI2BL

Replace these with your own access keys, found [here](https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=access-key).

As you probably don't want to check this data into source control, I'd recommend you just set it to an environment variable on your local box, and use ERB

    s3_access_key_id: <%= ENV['ACCESS_KEY_ID'] %>
    s3_secret_access_key: <%= ENV['SECRET_ACCESS_KEY'] %>

You can then set these env variables in your .bash_profile


## Folders to upload

By default, jammit-s3 will upload your configured asset directly, along with public/images. However you can customize this using the `s3_upload_files` setting, which should be a list of file globs.

    # adds image uploads
    s3_upload_files:
      - public/css/images/**

## Setting permissions on uploaded s3 objects

By default, jammit-s3 uses the permission setting found on the s3 bucket. However, you can override this with the config:

    s3_permission: public_read

Valid permission options are:

`private`: Owner gets FULL_CONTROL. No one else has any access rights. This is the default.

`public_read`: Owner gets FULL_CONTROL and the anonymous principal is granted READ access. If this policy is used on an object, it can be read from a browser with no authentication.

`public_read_write`: Owner gets FULL_CONTROL, the anonymous principal is granted READ and WRITE access. This is a useful policy to apply to a bucket, if you intend for any anonymous user to PUT objects into the bucket.

`authenticated_read`: - Owner gets FULL_CONTROL, and any principal authenticated as a registered Amazon S3 user is granted READ access.

## Using CloudFront

For this to work you need to make sure you have the CloudFront enabled via you Amazon acccount page. Go here: http://aws.amazon.com/cloudfront/ and click "Sign Up"

To use CloudFront, simply add the following settings to config/assets.yml:

    use_cloudfront: on
    cloudfront_dist_id: XXXXXXXXXXXXXX
    cloudfront_domain: xyzxyxyz.cloudfront.net

Please note that cloudfront_dist_id is not the same as the CloudFront domain
name. Inside CloudFront management console select the
distribution, and you will see Distribution ID and Domain Name values.

This will use the CloudFront domain name for your assets instead of serving them from the (slow) S3 bucket.

### Known issues with CloudFront invalidation

1. It may reportedly take up to 15 minutes to invalidate all the CloudFront
caches around the globe (and Amazon charges for more than a certain number
of invalidations per month).

2. It's non-atomic from the perspective of the end-user: They may get an
older version of the site with a newer version of the JavaScript and CSS, or
vice versa.

3. It doesn't play nicely with aggressive HTTP caching. For example, once I
serve a script or a stylesheet, I would like it to be cached indefinitely
with no more round trips to see whether it is valid.

Given these constraints, there's still an important need for some kind of
content-based hashing. Done right, this assures that all files can be cached
indefinitely, and the user will always get matched HTML/JS/CSS files. (This currently
is in the works).

## Bugs / Feature Requests

To suggest a feature or report a bug:
http://github.com/railsjedi/jammit-s3/issues/


## Jammit Home Page

Jammit S3 is a simple wrapper around Jammit. To view the original Jammit docs, use http://documentcloud.github.com/jammit/

