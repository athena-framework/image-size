abstract struct Athena::ImageSize::Extractors::AbstractTIFF < Athena::ImageSize::Extractors::Extractor
  private enum Tag
    ImageWidth  = 0x0100
    ImageLength = 0x0101
  end

  private enum DataType
    BYTE      =  1 # 8-bit unsigned integer
    STRING    =  2 # 8-bit, NULL-terminated string
    USHORT    =  3 # 16-bit unsigned integer
    ULONG     =  4 # 32-bit unsigned integer
    URATIONAL =  5 # Two 32-bit unsigned integers
    SBYTE     =  6 # 8-bit signed integer
    UNDEFINED =  7 # 8-bit byte
    SSHORT    =  8 # 16-bit signed integer
    SLONG     =  9 # 32-bit signed integer
    SRATIONAL = 10 # Two 32-bit signed integers
    FLOAT     = 11 # 4-byte single-precision IEEE floating-point value
    DOUBLE    = 12 # 8-byte double-precision IEEE floating-point value
  end

  def self.extract(io : IO) : AIS::Image?
    offset = io.read_bytes UInt32, self.byte_format

    io.skip offset - 8 # Account for already read bytes
    num_dirent = io.read_bytes UInt16, self.byte_format
    num_dirent = (io.pos + 2) + (num_dirent * 12)

    width = height = nil
    until width && height
      raise "Reached end of directory entries in TIFF" if io.pos > num_dirent

      ifd = Bytes.new 12
      io.read_fully ifd
      ifd = IO::Memory.new ifd, false

      tag = Tag.new ifd.read_bytes UInt16, self.byte_format
      data_type = DataType.new ifd.read_bytes UInt16, self.byte_format

      ifd.skip 4

      entry_value = case data_type
                    when .byte?, .sbyte? then ifd.read_bytes(Int8, self.byte_format)
                    when .ushort?        then ifd.read_bytes(UInt16, self.byte_format)
                    when .sshort?        then ifd.read_bytes(Int16, self.byte_format)
                    when .ulong?         then ifd.read_bytes(UInt32, self.byte_format)
                    when .slong?         then ifd.read_bytes(Int32, self.byte_format)
                    else
                      next
                    end

      case tag
      in .image_width?  then width = entry_value
      in .image_length? then height = entry_value
      end
    end

    Image.new width, height, 0, format: :tiff
  end
end
