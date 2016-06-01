require 'ruby_string'

RSpec.describe RubyString do
  describe "new" do
    it "creates a new instance of string" do
      string1 = String.new
      string2 = String.new

      expect(string1.object_id).not_to eq(string2.object_id)
    end
  end

  describe "try_convert" do
    it "trys to convert an object into a string" do
      object = RubyString.new
      array = Array.new
      hash = Hash.new

      convert_object = String.try_convert(object)
      convert_array = String.try_convert(array)
      convert_hash = String.try_convert(hash)

      expect(convert_object).to be nil
      expect(convert_array).to be nil
      expect(convert_hash).to be nil
    end

    it "successfully converts an object to a string" do
      object = "hello world"

      conversion = String.try_convert(object)

      expect(conversion).to eq("hello world")
    end
  end

  describe "string \% argument" do
    # uses kernel::sprintf as per docs, incomplete understanding of this as of now

    it "subs integer input into a string with significant figures" do
      formatter = "%05d" % 123
      expect(formatter).to eq("00123")
    end

    it "can change the length of the output" do
      formatter = "%09d" % "10"
      expect(formatter).to eq("000000010")
    end

    it "can sub in arguments in order" do
      formatter = "%-5s: %08x" % [ "ID", 1234 ]
      expect(formatter).to eq("ID   : 000004d2")
    end

    it "can sub in defined values" do
      formatter = "hash[:key] = %{key}" % { key: "value" }
      expect(formatter).to eq("hash[:key] = value")
    end
  end

  describe "string * integer" do
    it "multiplies the content of a string" do
      string = "Three"

      string_multiplier = string * 3

      expect(string_multiplier).to eq("ThreeThreeThree")
    end
  end

  xdescribe "string + other_string" do
  end

  xdescribe "mutable strings" do
  end

  xdescribe "frozen strings" do
  end

  xdescribe "string << integer" do
  end

  xdescribe "string << object" do
  end

  xdescribe "string == object" do
  end

  xdescribe "string === object" do
  end

  xdescribe "string =~ object" do
  end

  xdescribe "string[things]" do
  end

  xdescribe "string ascii_only" do
  end

  xdescribe "string.b" do
  end

  xdescribe "string.bytes" do
  end

  xdescribe "bytesize" do
  end

  xdescribe "byteslice" do
  end

  xdescribe "capitalize" do
  end

  xdescribe "casecmp" do
  end

  xdescribe "center" do
  end

  xdescribe "chars" do
  end

  xdescribe "chomp" do
  end

  xdescribe "chomp!" do
  end

  xdescribe "chop" do
  end

  xdescribe "chr" do
  end

  xdescribe "clear" do
  end

  xdescribe "codepoints" do
  end

  xdescribe "concat" do
  end

  xdescribe "count" do
  end

  xdescribe "crypt" do
  end

  xdescribe "delete" do
  end

  xdescribe "downcase" do
  end

  xdescribe "dump" do
  end

  xdescribe "each_byte" do
  end

  xdescribe "each_char" do
  end

  xdescribe "each_codepoint" do
  end

  xdescribe "each_line" do
  end

  xdescribe "empty?" do
  end

  xdescribe "encode" do
  end

  xdescribe "encoding" do
  end

  xdescribe "end_with?" do
  end

  xdescribe "eql?" do
  end

  xdescribe "force_encoding" do
  end

  xdescribe "freeze" do
  end

  xdescribe "getbyte" do
  end

  xdescribe "gsub" do
  end

  xdescribe "hash" do
  end

  xdescribe "hex" do
  end

  xdescribe "include?" do
  end

  xdescribe "index" do
  end

  xdescribe "replace" do
  end

  xdescribe "insert" do
  end

  xdescribe "inspect" do
  end

  xdescribe "intern" do
  end

  xdescribe "length" do
  end

  xdescribe "length" do
  end

  xdescribe "lines" do
  end

  xdescribe "ljust" do
  end

  xdescribe "lstrp" do
  end

  xdescribe "match" do
  end

  xdescribe "next" do
  end

  xdescribe "oct" do
  end

  xdescribe "ord" do
  end

  xdescribe "partition" do
  end

  xdescribe "prepend" do
  end

  xdescribe "replace" do
  end

  xdescribe "reverse" do
  end

  xdescribe "rindex" do
  end

  xdescribe "rindex" do
  end

  xdescribe "rjust" do
  end

  xdescribe "rpartition" do
  end

  xdescribe "rstrip" do
  end

  xdescribe "scan" do
  end

  xdescribe "scrub" do
  end

  xdescribe "setbyte" do
  end

  xdescribe "slice" do
  end

  xdescribe "split" do
  end

  xdescribe "squeeze" do
  end

  xdescribe "start_with?" do
  end

  xdescribe "strip" do
  end

  xdescribe "sub" do
  end

  xdescribe "succ" do
  end

  xdescribe "sum" do
  end

  xdescribe "swapcase" do
  end

  xdescribe "to_c" do
  end

  xdescribe "to_f" do
  end

  xdescribe "to_i" do
  end

  xdescribe "to_r" do
  end

  xdescribe "to_s" do
  end

  xdescribe "to_sym" do
  end

  xdescribe "tr" do
  end

  xdescribe "tr_s" do
  end

  xdescribe "unpack" do
  end

  xdescribe "upcase" do
  end

  xdescribe "upto" do
  end

  xdescribe "valid_encoding?" do
  end
end
