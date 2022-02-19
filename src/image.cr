record Athena::ImageSize::Image, width : Int32, height : Int32, bits : Int32, format : AIS::Image::Format, channels : Int32 = 0 do
  def self.new(width : Int, height : Int, bits : Int, format : AIS::Image::Format, channels : Int = 0) : self
    new width.to_i, height.to_i, bits.to_i, format, channels.to_i
  end

  def self.from_file_path(path : String | Path) : self
    self.from_io?(File.open(path)) || raise "Failed to parse"
  end

  def self.from_file_path?(path : String | Path) : self?
    self.from_io? File.open path
  end

  def self.from_io(io : IO) : self
    self.from_io?(io) || raise "Failed to parse"
  end

  def self.from_io?(io : IO) : self?
    AIS::Extractors::Extractor.from_io(io).extract io
  rescue
    nil
  ensure
    io.close
  end

  def size : Tuple(Int32, Int32)
    {@width, @height}
  end
end
