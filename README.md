# sentinel_s3

Ruby library for extracting Sentinel-2 tile metadata from [Amazon S3](https://aws.amazon.com/public-datasets/sentinel-2/).
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

Get productInfo.json object paths for all products from 2017-12-14
```ruby
products = client.get_products("2017-12-14") # YYYY-MM-DD 
# =>
# [
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCD_20171214T234716/productInfo.json",
# "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCE_20171214T234716/productInfo.json,
# ]
```

Get product and tile metadata
```ruby
product = "products/2017/12/14/S2B_MSIL1C_20171214T230119_N0206_R015_T58FCD_20171214T234716/productInfo.json"
metadata = client.parse_product_info(product)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/beaorn/sentinel_s3.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
