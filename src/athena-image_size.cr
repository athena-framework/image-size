require "./image_format"
require "./exceptions/*"
require "./extractors/*"
require "./image"

# Convenience alias to make referencing `Athena::ImageSize` types easier.
alias AIS = Athena::ImageSize

module Athena::ImageSize
  VERSION = "0.1.0"

  class_property dpi : Float64 { 72.0 }
end
