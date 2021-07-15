struct Athena::ImageSize::Extractors::APNG < Athena::ImageSize::Extractors::AbstractPNG
  protected def self.format : AIS::Image::Format
    AIS::Image::Format::APNG
  end
end
