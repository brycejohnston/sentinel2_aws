module SentinelS3
  class Client
    S3_REGION = 'eu-central-1'
    S3_BUCKET = 'sentinel-s2-l1c'

    def initialize(akid, secret)
      Aws.config.update({
        credentials: Aws::Credentials.new(akid, secret),
        region: S3_REGION
      })
      @s3_resource = Aws::S3::Resource.new
      @s3_client = Aws::S3::Client.new
      @directory = Dir.mktmpdir
    end

    def parse_date(date)
      y, m, d = date.split '-'
      y, m, d = y.to_i, m.to_i, d.to_i
      if Date.valid_date? y, m, d
        return [y, m, d]
      else
        return nil
      end
    end

    # date format: "YYYY-MM-DD"
    def get_products(date)
      pdate = parse_date(date)
      unless pdate.nil?
        year, month, day = pdate
        prefix = "products/#{year}/#{month}/#{day}/"
        folder = "#{year}_#{month}_#{day}"
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
      else
        return []
      end
    end

    def parse_product_info(product)
      product_str = product.split('/')
      folder = "#{product_str[1]}_#{product_str[2]}_#{product_str[3]}"
      download_file(product, folder, "#{product_str[4]}.json")
    end

    def download_file(s3_file, folder, filename)
      if @s3_resource.bucket(S3_BUCKET).object(s3_file).exists?
        base_dir = "#{@directory}/#{folder}"
        Dir.mkdir(base_dir) unless File.exists?(base_dir)
        filepath = "#{base_dir}/#{filename}"
        obj = @s3_resource.bucket(S3_BUCKET).object(s3_file)
        obj.get(response_target: filepath)
      else
        puts "Error: File doesn't exist"
      end
    end

    def remove_directory
      FileUtils.remove_entry @directory
    end

  end
end
