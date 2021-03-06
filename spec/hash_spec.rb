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

  context "Operators" do
    describe " < " do
      it "returns true if the hash on the left is a subset of the hash on the right" do
        hash1 = {a:1, b:2}
        hash2 = {a:1, b:2, c:3}

        evaluate = hash1 < hash2

        expect(evaluate).to be true
      end

      it "returns false if not" do
        hash1 = {a:1, b:2, c:3}
        hash2 = {a:1, b:2}

        evaluate = hash1 < hash2

        expect(evaluate).to be false
      end

      it "returns false if they are equal" do
        hash1 = {a:1, b:2, c:3}
        hash2 = {a:1, b:2, c:3}

        evaluate = hash1 < hash2

        expect(evaluate).to be false
      end

      it "raises an error if there is no conversion of object into a hash" do
        not_a_hash = "not a hash"
        hash = { a: 1, b: 2 }

        expect{ hash < not_a_hash }.to raise_error(TypeError, /(no implicit conversion of)|(into Hash)/)
      end
    end

    describe " <= " do
      it "returns true if they are equal" do
        hash1 = {a:1, b:2, c:3}
        hash2 = {a:1, b:2, c:3}

        evaluate = hash1 <= hash2

        expect(evaluate).to be true
      end

      it "returns true if the hash on the left is a subset of the hash on the right" do
        hash1 = {a:1, b:2}
        hash2 = {a:1, b:2, c:3}

        evaluate = hash1 <= hash2

        expect(evaluate).to be true
      end

      it "returns false if not" do
        hash1 = {a:1, b:2, c:3}
        hash2 = {a:1, b:2}

        evaluate = hash1 <= hash2

        expect(evaluate).to be false
      end

      it "raises an error if there is no conversion of object into a hash" do
        not_a_hash = "not a hash"
        hash = { a: 1, b: 2 }

        expect{ hash <= not_a_hash }.to raise_error(TypeError, /(no implicit conversion of)|(into Hash)/)
      end
    end

    describe " == " do
      it "returns true if the two hashes are in equality" do
        h1 = { a: 1, b: 2, c: 3 }
        h2 = { a: 1, b: 2, c: 3 }

        expect( h1 == h2 ).to be true
      end

      it "returns false if the two hashes are of equal length, but do not contain the same key value pairs" do
        h2 = { a: 1, b: 2, c: 3 }
        h3 = { a: 1, b: 2, c: 5 }

        expect( h2 == h3 ).to be false
      end

      it "returns false if the two hashes are not of equal length" do
        h3 = { a: 1, b: 2, c: 5 }
        h4 = { a: 1, b: 2 }

        expect( h3 == h4 ).to be false
      end
    end

    describe " > " do
      it "returns true of the hash on the left is greater than the hash on the right" do
        smaller = { a: 1, b: 2 }
        bigger  = { a: 1, b: 2, c: 3}

        evaluate = bigger > smaller

        expect(evaluate).to be true
      end

      it "returns false if not" do
        smaller = { a: 1, b: 2 }
        bigger  = { a: 1, b: 2, c: 3}

        evaluate = smaller > bigger

        expect(evaluate).to be false
      end

      it "raises an error if there is no conversion of object into a hash" do
        not_a_hash = "not a hash"
        hash = { a: 1, b: 2 }

        expect{ hash > not_a_hash }.to raise_error(TypeError, /(no implicit conversion of)|(into Hash)/)
      end
    end

    describe " >= " do
      it "returns true of the hash on the left is greater than or equal to the hash on the right" do
        smaller = { a: 1, b: 2 }
        bigger  = { a: 1, b: 2, c: 3}
        same_as_bigger = { a: 1, b: 2, c: 3 }

        evaluate = bigger >= same_as_bigger

        expect(evaluate).to be true
      end

      it "returns false if not" do
        smaller = { a: 1, b: 2 }
        bigger  = { a: 1, b: 2, c: 3}

        evaluate = smaller >= bigger

        expect(evaluate).to be false
      end

      it "raises an error if there is no conversion of object into a hash" do
        not_a_hash = "not a hash"
        hash = { a: 1, b: 2 }

        expect{ hash > not_a_hash }.to raise_error(TypeError, /(no implicit conversion of)|(into Hash)/)
      end
    end
  end

  context "Public Instance Methods" do
    describe "hsh[key]" do
      it "returns the assigned value of the key" do
        hash = { key: "value" }

        expect(hash[:key]).to eq("value")
      end

      it "returns nil if there is no assigned value" do
        hash = {}

        expect(hash[:key]).to be nil
      end
    end

    describe "hsh[key] = value" do
      it "assigns the provided key a value" do
        hash = { }

        hash[:key] = "value"

        expect(hash[:key]).to eq("value")
      end

      xit "implicitly returns the value that was assigned" do
      end
    end

    describe "#any?" do
      it "enumerates through the hash and returns true if a value is contained in the hash" do
        hash = { a: 1, b: 2, c: 3 }

        eval = hash.any?{ |k, v| k.to_s == "c" }

        expect(eval).to be true
      end

      it "returns false if a value is NOT contained in the hash" do
        hash = { a: 1, b: 2, c: 3 }

        eval = hash.any?{ |k, v| k.to_s == "d" }

        expect(eval).to be false
      end
    end

    describe "#assoc()" do
      it "uses object and searches through the keys of the hash looking for a match using the == operator" do
        hash = { "a" => 1, "b" => 2, "c" => 3 }
        matcher = "a"

        association = hash.assoc(matcher)

        expect(association).to be_a(Array)
        expect(association).to eq(["a", 1])
      end

      it "returns the key and the value(s) associated with it in a two part array" do
        hash = { "a" => [1, 2, 3], "b" => [2, 3, 4], "c" => [3, 4, 5] }
        matcher = "b"

        association = hash.assoc(matcher)

        expect(association).to be_a(Array)
        expect(association).to eq( ["b", [2, 3, 4]] )
      end

      it "returns nil if there is no match" do
        hash = { "a" => 1, "b" => 2, "c" => 3 }
        matcher = "z"

        association = hash.assoc(matcher)

        expect(association).to be nil
      end
    end

    describe "#clear" do
      it "removes all key-value pairs from the hash" do
        hash = { "a" => 1, "b" => 2, "c" => 3 }

        cleared_hash = hash.clear

        expect(cleared_hash).to be_a(Hash)
        expect(cleared_hash).to eq({})
      end
    end

    xdescribe "#compare_by_identity" do
    end

    xdescribe "#compare_by_identity?" do
    end

    describe "#default" do
      it "this returns the default value of the hash" do
        hash = Hash.new("default_value")  # Assigns default value

        default_value = hash.default

        expect(hash.default).to eq("default_value")
      end

      it "returns nil if there was no default value provided" do
        hash = Hash.new   # No default value assigned

        default_value = hash.default

        expect(default_value).to be nil
      end
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