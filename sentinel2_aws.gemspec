
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sentinel2_aws/version"

Gem::Specification.new do |spec|
  spec.name          = "sentinel2_aws"
  spec.version       = Sentinel2Aws::VERSION
  spec.authors       = ["Bryce Johnston"]
  spec.email         = ["bryce@agdeveloper.com"]

  spec.summary       = %q{Sentinel-2 metadata parser and downloader from AWS}
  spec.description   = %q{Sentinel-2 metadata parser and downloader from AWS}
  spec.homepage      = "https://github.com/satgateway/sentinel2_aws"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oj", "< 4"
  spec.add_dependency "aws-sdk", "~> 3"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
