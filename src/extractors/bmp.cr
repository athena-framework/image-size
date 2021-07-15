require "./extractor"

struct Athena::ImageSize::Extractors::BMP < Athena::ImageSize::Extractors::Extractor
  private SIGNATURE = Bytes['B'.ord, 'M'.ord, read_only: true]

  # Based on https://github.com/php/php-src/blob/95da6e807a948039d3a42defbd849c4fed6cbe35/ext/standard/image.c#L100.
  def self.extract(io : IO) : AIS::Image
    io.skip 11 # Skip rest of Header chunk

    info_header_length = io.read_bytes UInt32

    if 12 == info_header_length # BITMAPCOREHEADER
      width = io.read_bytes Int16
      height = io.read_bytes Int16

      io.skip 3

      bits = io.read_bytes UInt8
    elsif 40 == info_header_length # BITMAPINFOHEADER
      width = io.read_bytes Int32
      height = io.read_bytes(Int32).abs

      io.skip 2

      bits = io.read_bytes UInt16
    else
      raise "Unsupported BMP file format"
    end

    Image.new width, height, bits, :bmp, 0
  end

  def self.matches?(io : IO, bytes : Bytes) : Bool
    bytes[0, 2] == SIGNATURE
  end
end
