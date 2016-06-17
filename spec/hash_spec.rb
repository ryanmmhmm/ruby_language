RSpec.describe Hash do
  context "Public Class Methods" do
    xdescribe "Hash[ ]" do
    end

    describe ".new" do
      it "creates a new instance of Hash" do
        hash = Hash.new

        expect(hash).to be_a(Hash)
      end

      it "an object can be passed into Hash to set a default value, responds to any key" do
        string_hash = Hash.new("hello")

        expect(string_hash).to be_a(Hash)
        expect(string_hash["a"]).to eq("hello")
        expect(string_hash[:b]).to eq("hello")
      end

      it "accepts a block which can assign a value" do
        block_hash = Hash.new { |hash, key| hash[key] = "this is what I am: '#{key}'" }

        expect(block_hash).to be_a(Hash)
        expect(block_hash["default_value"]).to eq("this is what I am: 'default_value'")
      end
    end

    describe ".try_convert()" do
      it "uses the #to_hash convert the given object into a Hash.  Returns nil if the object cannot be converted" do
        integer_try = Hash.try_convert(123)
        key_value_try = Hash.try_convert("hello": "how are you?")
        string_try = Hash.try_convert("string")

        expect(integer_try).to be nil
        expect(key_value_try).to be_a(Hash)
        expect(string_try).to be nil
      end
    end
  end

  context "Public Instance Methods" do
    xdescribe " < " do
    end

    xdescribe " <= " do
    end

    xdescribe " == " do
    end

    xdescribe " > " do
    end

    xdescribe " >= " do
    end

    xdescribe "hsh[key]" do
    end

    xdescribe "hsh[key] = value" do
    end

    xdescribe "#any?" do
    end

    xdescribe "#assoc()" do
    end

    xdescribe "#clear" do
    end

    xdescribe "#compare_by_identity" do
    end

    xdescribe "#compare_by_identity?" do
    end

    xdescribe "#default" do
    end

    xdescribe "#default = obj" do
    end

    xdescribe "#default_proc" do
    end

    xdescribe "#default_proc = " do
    end

    xdescribe "#delete(key)" do
    end

    xdescribe "#delete_if" do
    end

    xdescribe "#dig(key)" do
    end

    xdescribe "#each" do
    end

    xdescribe "#each_pair" do
    end

    xdescribe "#each_key" do
    end

    xdescribe "#each_value" do
    end

    xdescribe "#empty?" do
    end

    xdescribe "#fetch(key)" do
    end

    xdescribe "#fetch_values" do
    end

    xdescribe "#flatten" do
    end

    xdescribe "#has_key?" do
    end

    xdescribe "#has_value?" do
    end

    xdescribe "#hash" do
    end

    xdescribe "#include?" do
    end

    xdescribe "#to_s" do
    end

    xdescribe "#inspect" do
    end

    xdescribe "#invert" do
    end

    xdescribe "#keep_if" do
    end

    xdescribe "#key(value)" do
    end

    xdescribe "#key(key)" do
    end

    xdescribe "#key?(key)" do
    end

    xdescribe "#keys" do
    end

    xdescribe "#length" do
    end

    xdescribe "#member?(key)" do
    end

    xdescribe "#merge(a_hash)" do
      xit "merge combines the contents of two hashes" do
      end

      xit "merge! mutates the hash in place" do
      end
    end

    xdescribe "#rassoc(obj)" do
    end

    xdescribe "#rehash" do
    end

    xdescribe "#reject" do
      xit "returns a new hash of entries for which the hash returned false" do
      end

      xit "reject! mutates the object in place" do
      end
    end

    xdescribe "#replace(a_hash)" do
    end

    xdescribe "#select" do
      xit "returns a new hash of entries for which the hash returned true" do
      end

      xit "select! mutates the object in place" do
      end
    end

    xdescribe "#shift" do
    end

    xdescribe "#size" do
    end

    xdescribe "#store(key, value)" do
    end

    xdescribe "#to_a" do
    end

    xdescribe "#to_h" do
    end

    xdescribe "#to_hash" do
    end

    xdescribe "#to_proc" do
    end

    xdescribe "#to_s" do
    end

    xdescribe "#update(a_hash)" do
    end

    xdescribe "#value?(value)" do
    end

    xdescribe "#values" do
    end

    xdescribe "#values_at(key, ...)" do
    end
  end
end