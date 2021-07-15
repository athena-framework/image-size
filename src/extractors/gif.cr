struct Athena::ImageSize::Extractors::GIF < Athena::ImageSize::Extractor
  private SIGNATURE = Bytes['G'.ord, 'I'.ord, 'F'.ord, read_only: true]

  # Based on https://github.com/php/php-src/blob/95da6e807a948039d3a42defbd849c4fed6cbe35/ext/standard/image.c#L100.
  def self.extract(io : IO) : AIS::Image
    io.skip 3 # Skip the version string

    width = io.read_bytes(UInt16)
    height = io.read_bytes(UInt16)

    packed_bit = io.read_byte.not_nil!

    # Not 100% sure what this is doing, probably parsing something from the packed field.
    bits = !(packed_bit & 0x80).zero? ? ((packed_bit & 0x07) + 1) : 0

    AIS::Image.new width, height, bits, :gif, 3
  end

  protected def self.signature : Bytes
    SIGNATURE
  end
end
