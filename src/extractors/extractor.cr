abstract struct Athena::ImageSize::Extractors::Extractor
  def self.from_io(io : IO) : self.class
    bytes = Bytes.new 3
    io.read_fully bytes

    return PNG if PNG.matches? io, bytes
    return JPEG if JPEG.matches? io, bytes
    return GIF if GIF.matches? io, bytes
    return BMP if BMP.matches? io, bytes
    return APNG if APNG.matches? io, bytes

    # Read in an additionl type to determine the format.
    bytes = Bytes.new 4
    io.pos -= 3
    io.read_fully bytes

    return ICO if ICO.matches? io, bytes
    return CUR if CUR.matches? io, bytes

    raise "Could not determine extractor from provided bytes."
  end
end
