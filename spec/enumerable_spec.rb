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

    xdescribe "#any?" do
    end

    xdescribe "#chunk" do
    end

    xdescribe "#chunk_while" do
    end

    xdescribe "#collect" do
    end

    xdescribe "#collect_count" do
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