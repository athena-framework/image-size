record Athena::ImageSize::Image, width : UInt32, height : UInt32, bits : UInt32, format : AIS::Image::Format, channels : UInt32 = 0 do
  def self.new(width : Int, height : Int, bits : Int, format : Format, channels : Int = 0) : self
    new width.to_u32, height.to_u32, bits.to_u32, format, channels.to_u32
  end

  def self.from_file_path(path : String | Path) : self
    self.from_io File.open path
  end

  def self.from_io(io : ::IO) : self
    extractor = AIS::Extractor.from_io io
    image = extractor.extract io
    io.close
    image
  end

  def size : Tuple(UInt32, UInt32)
    {@width, @height}
  end
end
