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

    def get_product_info(product)
      product_str = product.split('/')
      folder = "#{product_str[1]}_#{product_str[2]}_#{product_str[3]}"
      filepath = download_file(product, folder, "#{product_str[4]}.json")
      unless filepath.nil?
        file = File.read(filepath)
        product_info = Oj.load(file)
        FileUtils.remove_entry(filepath)
        tiles = []
        product_info["tiles"].each do |tile|
          tile_path = tile["path"]
          tile_name = tile_path.gsub("/", "_")
          tile = "#{tile["path"]}/tileInfo.json"
          tile_filepath = download_file(tile, folder, "#{tile_name}.json")
          unless tile_filepath.nil?
            tile_file = File.read(tile_filepath)
            tile_info = Oj.load(tile_file)
            FileUtils.remove_entry(tile_filepath)

            tile_metadata = {
              path: tile_info["path"],
              timestamp: tile_info["timestamp"],
              utm_zone: tile_info["utmZone"],
              latitude_band: tile_info["latitudeBand"],
              grid_square: tile_info["gridSquare"],
              data_coverage_percentage: tile_info["dataCoveragePercentage"],
              cloudy_pixel_percentage: tile_info["cloudyPixelPercentage"]
            }
            tiles << tile_metadata
          end
        end

        metadata = {
          name: product_info["name"],
          id: product_info["id"],
          path: product_info["path"],
          timestamp: product_info["timestamp"],
          datatake_identifier: product_info["datatakeIdentifier"],
          scihub_ingestion: product_info["sciHubIngestion"],
          s3_ingestion: product_info["s3Ingestion"],
          tiles: tiles
        }
      end
    end

    def download_file(s3_file, folder, filename)
      if @s3_resource.bucket(S3_BUCKET).object(s3_file).exists?
        base_dir = "#{@directory}/#{folder}"
        Dir.mkdir(base_dir) unless File.exists?(base_dir)
        filepath = "#{base_dir}/#{filename}"
        obj = @s3_resource.bucket(S3_BUCKET).object(s3_file)
        obj.get(response_target: filepath)
        return filepath
      else
        return nil
      end
    end

    def download_tile_data(tile_path, filename, output_path)
      s3_file = "#{tile_path}/#{filename}"
      if @s3_resource.bucket(S3_BUCKET).object(s3_file).exists?
        filepath = "#{output_path}/#{filename}"
        obj = @s3_resource.bucket(S3_BUCKET).object(s3_file)
        obj.get(response_target: filepath)
        return filepath
      else
        return nil
      end
    end

    def remove_directory
      FileUtils.remove_dir(@directory)
    end

  end
end
