struct Athena::ImageSize::Extractors::JP2 < Athena::ImageSize::Extractors::Extractor
  private SIGNATURE = Bytes[0x00, 0x00, 0x00, 0x0c, 0x6a, 0x50, 0x20, 0x20, 0x0d, 0x0a, 0x87, 0x0a, read_only: true]
  private BOX_ID    = Bytes[0x6a, 0x70, 0x32, 0x63, read_only: true]

  def self.extract(io : IO) : AIS::Image
    image = nil

    loop do
      box_length = io.read_bytes UInt32, IO::ByteFormat::BigEndian # LBox

      box_type = Bytes.new 4
      io.read_fully box_type # TBox

      case box_length
      when 1
        box_length = io.read_bytes UInt64, IO::ByteFormat::BigEndian
        raise IO::Error.new "Unexpected xl-box size: #{box_length}" if box_length.in? 1..15
      when 2..7
        raise IO::Error.new "Reserved box length: #{box_length}"
      end

      if BOX_ID == box_type
        io.skip 3

        return JPC.extract io
      end

      break if box_length <= 0

      # Skip LBox
      io.skip box_length - 8
    end

    if image.nil?
      raise IO::Error.new "JP2 file has no codestreams at root level."
    end

    image
  end

  def self.matches?(io : IO, bytes : Bytes) : Bool
    bytes[0, 12] == SIGNATURE
  end
end
