require "./extractor"

abstract struct Athena::ImageSize::Extractors::AbstractICO < Athena::ImageSize::Extractors::Extractor
  # Based on https://github.com/php/php-src/blob/95da6e807a948039d3a42defbd849c4fed6cbe35/ext/standard/image.c#L100.
  def self.extract(io : IO) : AIS::Image
    # Skip count of images in file
    io.skip 2

    width = io.read_bytes UInt8
    height = io.read_bytes UInt8

    # Skip color count, reserved bit, and color plantes
    io.skip 4

    bits = io.read_bytes UInt16

    Image.new width.zero? ? 256 : width, height.zero? ? 256 : height, bits, self.format
  end
end
