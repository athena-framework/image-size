require "./image_format"
require "./extractors/*"
require "./image"

# Convenience alias to make referencing `Athena::ImageSize` types easier.
alias AIS = Athena::ImageSize

module Athena::ImageSize
  VERSION = "0.1.0"

  # Represents the [DPI (Dots Per Inch)](https://en.wikipedia.org/wiki/Dots_per_inch) used to calculate dimensions of `AIS::Image::Format::SVG` images.
  # Defaults to `72.0`.
  class_property dpi : Float64 { 72.0 }

  # :nodoc:
  module Extractors; end
end
