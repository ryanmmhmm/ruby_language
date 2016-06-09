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
        inputs = [Array.new, Hash.new, 1, 1.0, false]

        enum_any = inputs.any? { |i| i == false }

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

    describe "#count" do
      it "returns the number of items in emum" do
        five_things = [1,2,3,4,5]

        counted = five_things.count

        expect(counted).to eq(5)
      end

      it "returns the number of items in enum that match the argument in the block" do
        five_things = [1,2,3,4,5]

        even_things = five_things.count { |num| num.even? }

        expect(even_things).to eq(2)
      end

      it "returns the number of items in enum matching item provided" do
        five_things = [5,5,5,5,5]

        no_of_fives = five_things.count(5)

        expect(no_of_fives).to eq(5)
      end

      it "returns zero if there is no item match" do
        all_fives = [5,5,5,5,5]

        no_of_sixes = all_fives.count(6)

        expect(no_of_sixes).to eq(0)
      end
    end

    describe "#cycle(n)" do
      it "can cycle forever with (1..2).cycle { |val| puts val } unless interrupted" do
        # trust me....
      end

      it "will cycle a limtited number of times according to the value of 'n' provided" do
        n = 5
        thing_to_cycle = [1]

        cycled_thing = []
        thing_to_cycle.cycle(n) { |thing| cycled_thing << thing }

        expect(cycled_thing).to eq([1]*5)
      end

      it "returns nil if the loop completes without interruption" do
        n = 5
        thing_to_cycle = [1]

        nil_please = thing_to_cycle.cycle(n) { |thing| thing }

        expect(nil_please).to be nil
      end

      it "returns an Enumerator object if no block is provided" do
        expect((1..2).cycle(3)).to be_a(Enumerator)
      end
    end

    describe "#detect(ifnone)" do
      it "returns the first value for which the block is not false" do
        scope = (1..10)

        detected = scope.detect { |val| val == 5 }

        expect(detected).to eq(5)
      end

      it "returns nil if there is no match from the block" do
        scope = (1..10)

        detected = scope.detect { |val| val == 9001 }

        expect(detected).to be nil
      end

      it "returns ifnone if there is no match from the block and ifnone is defined (ifnone must be a lambda or proc)" do
        scope = (1..10)
        ifnone = ->() { "nope!" }  #or lambda { "nope!" }

        detected = scope.detect(ifnone) { |val| val == 9001 }

        expect(detected).to eq("nope!")
      end
    end

    describe "#drop(n)" do
      it "returns an array excluding the elements from index 0 - (n-1)" do
        array = [1] * 5

        dropped = array.drop(3)

        expect(dropped).to be_a(Array)
        expect(dropped).to eq([1,1])
      end

      it "can accept inputs in other ways" do
        input = (1..5)
        input2 = "string"

        dropped = input.drop(3)
        dropped2 = input2.each_char.drop(3).join('')

        expect(dropped).to eq([4,5])
        expect(dropped2).to eq("ing")
      end

      it "raises an error if 'n' is negative" do
        array = [1] * 5

        expect{ array.drop(-3) }.to raise_error(ArgumentError, /attempt to drop negative size/)
      end

      it "raises an error if no value for 'n' is provided" do
        array = [5] * 5

        expect{ array.drop }.to raise_error(ArgumentError, /.*(wrong number of arguments)+.*(expected 1)+.*/)
        expect{ array.drop }.to raise_error(ArgumentError, "wrong number of arguments (given 0, expected 1)")  # or for those who like matching errors with strings
      end
    end

    describe "#drop_while" do
      it "returns an array, dropping elements until the block condition is satisfied" do
        theres_only_one_six = [1,2,3,4,5,6,7,8,9,0]

        dropped = theres_only_one_six.drop_while { |val| val != 6 }

        expect(dropped).to be_a(Array)
        expect(dropped).to eq([6,7,8,9,0])
      end

      it "returns an Enumerator object if no block is supplied" do
        theres_only_one_six = [1,2,3,4,5,6,7,8,9,0]

        dropped = theres_only_one_six.drop_while

        expect(dropped).to be_a(Enumerator)
      end
    end

    xdescribe "#each_cons" do
    end

    xdescribe "#each_entry" do
    end

    xdescribe "#each_slice" do
    end

    describe "#each_with_index" do
      it "tracks the index with each enumeration" do
        index_array = [0,1,2,3,4]

        pointless_hash = {}
        index_array.each_with_index { |n, i| pointless_hash[n] = i }

        expect(pointless_hash[0]).to eq(0)
        expect(pointless_hash[4]).to eq(4)
        expect(pointless_hash[5]).to be nil
      end

      it "returns an Enumerator object when no block is supplied" do
        index_array = [0,1,2,3,4]

        pointless_hash = {}
        what_am_i = index_array.each_with_index

        expect(what_am_i).to be_a(Enumerator)
      end
    end

    describe "#each_with_object" do
      it "constructs an object from the enumerated data" do
        alphabet = ("a".."z").to_a

        counter = 1
        alphahash = alphabet.each_with_object({}) { |c, hash| hash[c.intern] = counter; counter += 1 }

        expect(alphahash).to be_a(Hash)
        expect(alphahash[:a]).to eq(1)
        expect(alphahash[:z]).to eq(26)
      end

      it "returns an Enumerator if no block is provided" do
        alphabet = ("a".."z").to_a

        alphahash = alphabet.each_with_object({})

        expect(alphahash).to be_a(Enumerator)
      end
    end

    xdescribe "#entries" do
    end

    xdescribe "#find" do
      # alias for detect, see Enumerable#detect in this file.
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