# sentinel2_aws

[![Gem Version](http://img.shields.io/gem/v/sentinel2_aws.svg)][gem]

[gem]: https://rubygems.org/gems/sentinel2_aws

Ruby library for parsing Sentinel-2 tile metadata and downloading tile data from [AWS](https://aws.amazon.com/public-datasets/sentinel-2/).
This is the primary mechanism for retrieving data for the [Sentinel-2 AWS Search API](https://github.com/CropQuest/sentinel2-search-api) project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sentinel2_aws'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sentinel2_aws

## Usage

Initialize Sentinel2Aws::Client
```ruby
client = Sentinel2Aws::Client.new("access_key_id", "secret_access_key")
```

Get productInfo.json object paths for all products by date: `get_products("YYYY-MM-DD")`
```ruby
products = client.get_products("2017-12-14")
# =>
# [
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCD_20171214T234716/productInfo.json",
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCE_20171214T234716/productInfo.json",
# ]
```

Get product and tile metadata
```ruby
# takes single productInfo.json path returned from get_products
product = "products/2017/12/15/S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047/productInfo.json"
metadata = client.get_product_info(product)
# =>
{
  :name => "S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047",
  :id => "eaedcad9-f287-41b8-944c-0cfed0b15db8",
  :path =>  "products/2017/12/15/S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047",
  :timestamp => "2017-12-15T23:57:29.027Z",
  :datatake_identifier => "GS2B_20171215T235729_004060_N02.06",
  :scihub_ingestion => "2017-12-16T01:46:29.112Z",
  :s3_ingestion => "2017-12-16T01:50:49.375Z",
  :tiles=>
    [
      {
        :path => "tiles/57/M/VR/2017/12/15/0",
        :timestamp => "2017-12-15T23:57:27.460Z",
        :utm_zone => 57,
        :latitude_band => "M",
        :grid_square => "VR",
        :epsg => "32757",
        :data_coverage_percentage => 31.21,
        :cloudy_pixel_percentage => 13.47
      }
    ]
}
```

Download tile data: `download_tile_data(s3 tile path, file, output path)`
```ruby
client.download_tile_data("tiles/57/M/VR/2017/12/15/0", "B01.jp2", "/path/that/exists")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beaorn/sentinel2_aws.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
