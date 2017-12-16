module SentinelS3
  class Client
    S3_URL = 'http://sentinel-s2-l1c.s3.amazonaws.com'
    S3_REGION = 'eu-central-1'
    S3_BUCKET = 'sentinel-s2-l1c'

    def initialize(akid, secret)
      Aws.config.update({
        credentials: Aws::Credentials.new(akid, secret),
        region: S3_REGION
      })
      @s3_resource = Aws::S3::Resource.new(region: S3_REGION, credentials: Aws::Credentials.new(akid, secret))
      @s3_client = Aws::S3::Client.new
    end

    def get_products(year, month, day)
      prefix = "products/#{year}/#{month}/#{day}/"
      objects = []

      @s3_client.list_objects(bucket: S3_BUCKET, prefix: prefix).each do |response|
        response.contents.each do |object|
          product_str = object.key.split(prefix)
          product = product_str[1].split('/')
          if product[1] == 'productInfo.json'
            objects << object.key
          end
        end
      end

      return objects
    end

    def get_product_info(product, filepath)
      if @s3.bucket(S3_BUCKET).object(product).exists?
        obj = @s3.bucket(S3_BUCKET).object(product)
        obj.get(response_target: filepath)
      else
        puts "Error: File doesn't exist"
      end
    end

  end
end
