RSpec.describe Enumerator do
  context "Public Class Methods" do
    describe ".new" do

    end
  end

  context "Public Instance Methods" do
    describe "#each" do
      it "iterates over the set called upon with the block provided" do
        check = "this one"

        array = ["this one", "that one", "which one", "what?"]
        result = ""
        array.each { |string| result << string if string == "this one" }

        expect(result).to eq("this one")
      end

      it "returns Enumerator object if no block is provided" do
        check = "this one"

        array = ["this one", "that one", "which one", "what?"]
        result = array.each

        expect(result).to be_a(Enumerator)
      end
    end

    describe "#each_with_index" do
      it "iterates over the set called upon with the block provided while tracking the index" do
        array = ["this one", "that one", "which one", "what?"]

        output = []
        index_array = []
        array.each_with_index { |string, index| output << string; index_array << index }

        expect(index_array).to eq([0,1,2,3])
        expect(output).to eq(["this one", "that one", "which one", "what?"])
      end

      it "returns an Enumerator object if there is no block" do
        array = ["this one", "that one", "which one", "what?"]

        result = array.each_with_index

        expect(result).to be_a(Enumerator)
      end
    end

    describe "#each_with_object" do
      it "also known as the memo pattern, it allows you to easily pass in a new object" do
        array = ["1", "2", "3", "4"]
        hash = {}

        array.each_with_object(hash) { |char, memo| memo[char.to_sym] = char }

        expect(hash).to be_a(Hash)
        expect(hash[:"1"]).to eq("1")
        expect(hash[:"2"]).to eq("2")
        expect(hash[:"3"]).to eq("3")
        expect(hash[:"4"]).to eq("4")
      end

      it "returns an Enumerator object if there is no block" do
        array = ["1", "2", "3", "4"]
        hash = {}

        result = array.each_with_object(hash)

        expect(result).to be_a(Enumerator)
      end
    end

    xdescribe "#feed" do
    end

    xdescribe "#next" do
    end

    xdescribe "#next_values" do
    end

    xdescribe "#peek" do
    end

    xdescribe "#peek_values" do
    end

    xdescribe "#rewind" do
    end

    xdescribe "#size" do
    end

    xdescribe "#with_index" do
    end

    xdescribe "#with_object" do
    end
  end
end