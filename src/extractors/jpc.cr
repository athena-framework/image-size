struct Athena::ImageSize::Extractors::JPC < Athena::ImageSize::Extractors::Extractor
  private SIGNATURE = Bytes[0xff, 0x4f, 0xff, read_only: true]

  private enum JPEG2000Marker : UInt8
    SIZ = 0x51

    def ==(other : UInt8) : Bool
      self.value == other
    end
  end

  def self.extract(io : IO) : AIS::Image
    # For reasons we're using the hight bit depth encountered.
    first_marker = io.read_byte.not_nil!

    if JPEG2000Marker::SIZ != first_marker
      raise IO::Error.new "JPEG2000 codestream corrupt(Expected SIZ marker not found after SOC)"
    end

    io.skip 4 # Skip Lsiz and Rsiz

    width = io.read_bytes UInt32, IO::ByteFormat::BigEndian
    height = io.read_bytes UInt32, IO::ByteFormat::BigEndian

    io.skip 24

    channels = io.read_bytes UInt16, IO::ByteFormat::BigEndian

    if (channels.zero? && io.read_byte.nil?) || channels > 256
      raise IO::Error.new "JPEG2000 error"
    end

    hightest_bit_depth = 0
    channels.times do
      bit_depth = io.read_byte.not_nil! + 1

      if bit_depth > hightest_bit_depth
        hightest_bit_depth = bit_depth
      end

      io.skip 2
    end

    Image.new width, height, hightest_bit_depth, :jpc, channels
  end

  def self.matches?(io : IO, bytes : Bytes) : Bool
    bytes[0, 3] == SIGNATURE
  end
end
