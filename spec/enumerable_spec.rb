RSpec.describe Enumerable do
  context "Public Instance Methods" do
    describe "#all?" do
      it "yields to the block each value of the specified input and returns true if all pass" do
        words_of_different_lengths = %W(a be see deed)

        enum_all = words_of_different_lengths.all? { |word| word.length < 5 }

        expect(enum_all).to be true
      end

      it "returns false if there a single value that does not meet the required criteria" do
        words_of_different_lengths = %W(a be see deed fiver)

        enum_all = words_of_different_lengths.all? { |word| word.length < 5 }

        expect(enum_all).to be false
      end

      it "returns true if no block given and all content is truthy" do
        words_of_different_lengths = %W(a be see deed fiver)

        enum_all = words_of_different_lengths.all?

        expect(enum_all).to be true
      end

      it "returns true for values other than strings" do
        inputs = [Array.new, Hash.new, 1, 1.0, true]

        enum_all = inputs.all?

        expect(enum_all).to be true
      end

      it "returns false if no block given and content is false or nil" do
        falsey_input = [false, nil, true]

        enum_all = falsey_input.all?

        expect(enum_all).to be false
      end
    end

    describe "#any?" do
      it "inverse of #all?, returns true for any inputs that meet the critera of the block" do
        inputs = [Array.new, Hash.new, 1, 1.0, true]

        enum_any = inputs.any? { |i| i == true }

        expect(enum_any).to be true
      end

      it "returns false if no values make the block return true" do
        inputs = [false, nil, true]

        enum_any = inputs.any? { |i| i == true }

        expect(enum_any).to be true
      end
    end

    xdescribe "#chunk" do
      ## this is a monster of an Enum.  fill out when a use case is recognized for better understanding.
    end

    xdescribe "#chunk_while" do
      ## this is a monster of an Enum. fill out when a use case is recognized for better understanding.
    end

    describe "#collect" do
      it "yields to the block the value of the inputs and returns an array" do
        feelings = %W(grumpy hungry purring sleeping athletic)

        kinds_of_cats = feelings.collect { |f| f + " cat" }

        expect(kinds_of_cats).to eq(["grumpy cat", "hungry cat", "purring cat", "sleeping cat", "athletic cat"])
      end

      it "can replace all values" do
        feelings = %W(grumpy hungry purring sleeping athletic)

        replaced_cats = feelings.collect { "asdf" }

        expect(replaced_cats).to eq(["asdf"]*5)
      end

      it "returns an Enumerator if no block is supplied" do
        months = %W(January February March)

        enumerator_object = months.collect

        expect(enumerator_object).to be_a(Enumerator)
      end
    end

    describe "#collect_concat" do
      it "returns an array with the concatinated results of running the block once for every element in enum" do
        months = [ "January", "February" ]
        temperature = "is cold"

        concatonated_results = months.collect_concat { |enum| enum + " " + temperature }

        expect(concatonated_results).to eq(["January is cold", "February is cold"])
      end

      it "can do other cool stuff" do
        numbers = (1..5).to_a

        double_jump = numbers.collect_concat { |enum| [enum, enum * 2] }

        expect(double_jump).to eq([1, 2, 2, 4, 3, 6, 4, 8, 5, 10])
      end

      it "returns an Enumerator if no block is supplied" do
        months = %W(January February March)

        enumerator_object = months.collect_concat

        expect(enumerator_object).to be_a(Enumerator)
      end
    end

    xdescribe "#count" do
    end

    xdescribe "#cycle" do
    end

    xdescribe "#detect" do
    end

    xdescribe "#drop" do
    end

    xdescribe "#drop_while" do
    end

    xdescribe "#each_cons" do
    end

    xdescribe "#each_entry" do
    end

    xdescribe "#each_entry" do
    end

    xdescribe "#each_slice" do
    end

    xdescribe "#each_with_object" do
    end

    xdescribe "#entries" do
    end

    xdescribe "#find" do
    end

    xdescribe "#find_all" do
    end

    xdescribe "#find_index" do
    end

    xdescribe "#first" do
    end

    xdescribe "#flat_map" do
    end

    xdescribe "#grep" do
    end

    xdescribe "#grep_v" do
    end

    xdescribe "#group_by" do
    end

    xdescribe "#include?" do
    end

    xdescribe "#inject" do
    end

    xdescribe "#lazy" do
    end

    xdescribe "#map" do
    end

    xdescribe "#max" do
    end

    xdescribe "#max_by" do
    end

    xdescribe "#member?" do
    end

    xdescribe "#max" do
    end

    xdescribe "#max_by" do
    end

    xdescribe "#member?" do
    end

    xdescribe "#min" do
    end

    xdescribe "#min_by" do
    end

    xdescribe "#minmax" do
    end

    xdescribe "#minmax_by" do
    end

    xdescribe "#none?" do
    end

    xdescribe "#one?" do
    end

    xdescribe "#partition" do
    end

    xdescribe "#reduce" do
    end

    xdescribe "#reject" do
    end

    xdescribe "#reverse_each" do
    end

    xdescribe "#select" do
    end

    xdescribe "#slice_after" do
    end

    xdescribe "#slice_before" do
    end

    xdescribe "#slice_when" do
    end

    xdescribe "#sort" do
    end

    xdescribe "#sort_by" do
    end

    xdescribe "#take" do
    end

    xdescribe "#take_while" do
    end

    xdescribe "#to_a" do
    end

    xdescribe "#to_h" do
    end

    xdescribe "#zip" do
    end
  end
end