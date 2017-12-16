# sentinel_s3

[![Gem Version](http://img.shields.io/gem/v/sentinel_s3.svg)][gem]
[gem]: https://rubygems.org/gems/sentinel_s3

Ruby library for extracting Sentinel-2 tile metadata and downloading tile data from [Amazon S3](https://aws.amazon.com/public-datasets/sentinel-2/).
This was created to be the primary mechanism for inserting data into the [Sentinel-2 S3 Search API](https://github.com/beaorn/s2) project.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sentinel_s3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sentinel_s3

## Usage

Initialize SentinelS3::Client
```ruby
client = SentinelS3::Client.new("access_key_id", "secret_access_key")
```

Get productInfo.json object paths for all products by date
```ruby
products = client.get_products("2017-12-14") # YYYY-MM-DD
# =>
# [
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCD_20171214T234716/productInfo.json",
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCE_20171214T234716/productInfo.json",
# ]
```

Get product and tile metadata
```ruby
# takes single productInfo.json path returned from get_products
product = "products/2017/12/15/S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047productInfo.json"
metadata = client.get_product_info(product)
# =>
{
  :name=>"S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047",
  :id=>"eaedcad9-f287-41b8-944c-0cfed0b15db8",
  :path=> "products/2017/12/15/S2B_MSIL1C_20171215T235729_N0206_R030_T57MVR_20171216T010047",
  :timestamp=>"2017-12-15T23:57:29.027Z",
  :datatake_identifier=>"GS2B_20171215T235729_004060_N02.06",
  :scihub_ingestion=>"2017-12-16T01:46:29.112Z",
  :s3_ingestion=>"2017-12-16T01:50:49.375Z",
  :tiles=>
    [
      {
        :path=>"tiles/57/M/VR/2017/12/15/0",
        :timestamp=>"2017-12-15T23:57:27.460Z",
        :utm_zone=>57,
        :latitude_band=>"M",
        :grid_square=>"VR",
        :data_coverage_percentage=>31.21,
        :cloudy_pixel_percentage=>13.47
      }
    ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beaorn/sentinel_s3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
