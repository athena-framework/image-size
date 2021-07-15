abstract struct Athena::ImageSize::Extractor
  def self.from_io(io : IO) : self.class
    bytes = Bytes.new 3
    io.read_fully bytes

    {% for extractor in AIS::Extractor.all_subclasses.reject &.abstract? %}
      return {{extractor}} if {{extractor}}.matches? io, bytes
    {% end %}

    raise "Could not determine extractor from provided bytes."
  end

  def self.matches?(io : IO, bytes : Bytes) : Bool
    bytes[0, 3] == self.signature
  end
end
