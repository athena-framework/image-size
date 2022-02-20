# Represents information related to a parsed image.
# Includes its dimensions as well as its number of bits, and channels if applicable.
struct Athena::ImageSize::Image
  getter width : Int32
  getter height : Int32
  getter bits : Int32?
  getter channels : Int32?
  getter format : Athena::ImageSize::Image::Format

  def initialize(width : Int, height : Int, @format : AIS::Image::Format, bits : Int? = nil, channels : Int? = nil)
    @width = width.to_i
    @height = height.to_i
    @bits = bits.try &.to_i
    @channels = channels.try &.to_i
  end

  def self.from_file_path(path : String | Path) : self
    self.from_io File.open path
  end

  def self.from_file_path?(path : String | Path) : self?
    self.from_io? File.open path
  end

  def self.from_io(io : IO) : self
    if extractor_type = AIS::Extractors::Extractor.from_io io
      return extractor_type.extract(io) || raise "Failed to parse image."
    end

    raise "Unsupported image format."
  end

  def self.from_io?(io : IO) : self?
    if extractor_type = AIS::Extractors::Extractor.from_io io
      return extractor_type.extract io
    end
  ensure
    io.close
  end

  def size : Tuple(Int32, Int32)
    {@width, @height}
  end
end
