require "./image_format"
require "./extractor"
require "./extractors/*"
require "./image"

# Convenience alias to make referencing `Athena::ImageSize` types easier.
alias AIS = Athena::ImageSize

module Athena::ImageSize
  VERSION = "0.1.0"
end
