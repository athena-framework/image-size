require "./spec_helper"

struct ImageTest < ASPEC::TestCase
  @[DataProvider("files")]
  def test_from_io(file_path : String)
    File.open file_path do |file|
      image = AIS::Image.from_io file

      filename = File.basename file_path

      # width, height, bits, channels, format
      /(\d+)x(\d+)_(\d+)_(\d+)\.(\w+)$/.match(filename)

      _, expected_width, expected_height, expected_bits, expected_channels, expected_format = $~

      expected_bits = "0" == expected_bits ? nil : expected_bits.to_i
      expected_channels = "0" == expected_channels ? nil : expected_channels.to_i

      image.width.should eq expected_width.to_i
      image.height.should eq expected_height.to_i
      image.bits.should eq expected_bits
      image.channels.should eq expected_channels
      image.format.should eq AIS::Image::Format.parse(expected_format)
    end
  end

  @[DataProvider("files")]
  def test_from_file_path(file_path : String)
    image = AIS::Image.from_file_path file_path

    filename = File.basename file_path

    # width, height, bits, channels, format
    /(\d+)x(\d+)_(\d+)_(\d+)\.(\w+)$/.match(filename)

    _, expected_width, expected_height, expected_bits, expected_channels, expected_format = $~

    expected_bits = "0" == expected_bits ? nil : expected_bits.to_i
    expected_channels = "0" == expected_channels ? nil : expected_channels.to_i

    image.width.should eq expected_width.to_i
    image.height.should eq expected_height.to_i
    image.bits.should eq expected_bits
    image.channels.should eq expected_channels
    image.format.should eq AIS::Image::Format.parse(expected_format)
  end

  def files : Hash
    Dir.glob("#{__DIR__}/images/*/*").each_with_object(Hash(String, Tuple(String)).new) do |name, hash|
      hash[name] = {name}
    end
  end
end
