
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sentinel_s3/version"

Gem::Specification.new do |spec|
  spec.name          = "sentinel_s3"
  spec.version       = SentinelS3::VERSION
  spec.authors       = ["Bryce Johnston"]
  spec.email         = ["bryce@agdeveloper.com"]

  spec.summary       = %q{Sentinel-S2 metadata crawler and extractor from Amazon S3}
  spec.description   = %q{Sentinel-S2 metadata crawler and extractor from Amazon S3}
  spec.homepage      = "https://github.com/beaorn/sentinel_s3"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
