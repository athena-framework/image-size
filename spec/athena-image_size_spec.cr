require "./spec_helper"

struct ImageTest < ASPEC::TestCase
  @[DataProvider("files")]
  def test_from_io(file_path : String)
    File.open file_path do |file|
      image = AIS::Image.from_io file

      filename = File.basename file_path

      # width, height, bits, channels, format
      /(\d+)x(\d+)_(\d+)_(\d+)\.(\w+)$/.match(filename)

      _, expected_width, expected_height, expected_bits, expected_chanels, expected_format = $~

      image.width.should eq expected_width.to_i
      image.height.should eq expected_height.to_i
      image.bits.should eq expected_bits.to_i
      image.channels.should eq expected_chanels.to_i
      image.format.should eq AIS::Image::Format.parse(expected_format)
    end
  end

  @[DataProvider("files")]
  def test_from_file_path(file_path : String)
    image = AIS::Image.from_file_path file_path

    filename = File.basename file_path

    /(\d+)x(\d+)_(\d+)_(\d+)\.(\w+)$/.match(filename)

    _, expected_width, expected_height, expected_bits, expected_chanels, expected_format = $~

    image.width.should eq expected_width.to_i
    image.height.should eq expected_height.to_i
    image.bits.should eq expected_bits.to_i
    image.channels.should eq expected_chanels.to_i
    image.format.should eq AIS::Image::Format.parse(expected_format)
  end

  def files : Array
    Dir.glob("#{__DIR__}/images/*/*").map { |name| {name} }
  end
end
