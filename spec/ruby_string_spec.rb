require 'ruby_string'

RSpec.describe RubyString do
  context "Public Methods" do
    describe "new" do
      it "creates a new instance of string" do
        string1 = String.new
        string2 = String.new

        expect(string1.object_id).not_to eq(string2.object_id)
      end
    end

    describe "try_convert" do
      it "trys to convert an object into a string" do
        class RubyString
          def to_str
            "RubyString"
          end
        end

        object = RubyString.new
        array = Array.new
        hash = Hash.new

        convert_object = String.try_convert(object)
        convert_array = String.try_convert(array)
        convert_hash = String.try_convert(hash)

        expect(convert_object).to eq("RubyString")
        expect(convert_array).to be nil
        expect(convert_hash).to be nil
      end

      it "successfully converts an object to a string" do
        object = "hello world"

        conversion = String.try_convert(object)

        expect(conversion).to eq("hello world")
      end
    end
  end

  context "OPERATORS" do
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

    describe "string + other_string" do
      it "concats two strings together" do
        first = "first"
        space = " "
        second = "second"

        string = first + space + second

        expect(string).to eq("first second")
      end

      let(:bad_concat) { "first" + " " + 1 }

      it "cannot concat a string and a non-string" do
        expect{ bad_concat }.to raise_error(TypeError, /no implicit conversion of Fixnum into String/)
      end
    end

    describe "mutable and immutable strings" do
      it "frozen strings can't be modified" do
        frozen_string = "I'm frozen!".freeze

        expect(frozen_string.frozen?).to be true
        expect{ frozen_string << "some chars" }.to raise_error(RuntimeError, /can't modify frozen String/)
      end

      # more to explore here but concentrate on it later
    end

    describe "string << " do
      it "can add 'integers' to strings" do
        string = "string"

        string = string << 1

        expect(string).to eq("string\u0001")
      end

      it "can concat integer values onto strings as codepoints" do
        string = "string"
        other_string = "".concat(105)

        string = string.concat(105)

        expect(other_string).to eq("i")
        expect(string).not_to eq("string")
        expect(string).to eq("stringi")
      end
    end

    describe " <=> (saucer operator)" do
      it "compares two strings together and returns a relative value" do
        all_caps = "ASDF"
        lower_case = "asdf"
        shorter = "asd"
        integer = 1

        expect(all_caps <=> lower_case).to eq(-1) #=> ASDF < asdf
        expect(lower_case <=> all_caps).to eq(1) #=> asdf > ASDF
        expect(lower_case <=> lower_case).to eq(0) #=> asdf == asdf
        expect(lower_case <=> shorter).to eq(1) #=> asdf > asd
        expect(shorter <=> lower_case).to eq(-1) #=> asd < asdf
        expect(shorter <=> shorter).to eq(0) #=> asd == asd
        expect(lower_case <=> integer).to be nil #=> apples and oranges
      end

      it "operates on the byte values of the strings" do
        all_caps = "ASDF"
        all_caps_backwards = "FDSA"
        lower_case = "asdf"
        lower_case_backwards = "fdas"

        sum_all_caps = all_caps.bytes.reduce(:+)
        sum_all_caps_backwards = all_caps_backwards.bytes.reduce(:+)
        sum_lower_case = lower_case.bytes.reduce(:+)
        sum_lower_case_backwards = lower_case_backwards.bytes.reduce(:+)

        expect(sum_all_caps).to eq(286)
        expect(sum_all_caps_backwards).to eq(286)
        expect(sum_lower_case).to eq(414)
        expect(sum_lower_case_backwards).to eq(414)

        expect(sum_all_caps <=> sum_all_caps_backwards).to eq(0)
        expect(sum_lower_case <=> sum_lower_case_backwards).to eq(0)
        expect(sum_all_caps <=> sum_lower_case).to eq(-1)
        expect(sum_lower_case <=> sum_all_caps ).to eq(1)
      end
    end

    describe "string == object" do
      it "compares equality of two strings" do
        string = "hello"

        expect(string == string).to be true
      end

      it "compares equality of two strings" do
        string = "hello"
        string2 = "goodbye"

        expect(string == string2).to be false
      end

      it "compares equality of a string and an object that responds to .to_str" do
        string = "hello"
        array = ["hello"]

        expect(string == array).to be false
      end
    end

    describe "string === object" do
      it "compares equality of two strings" do
        string = "hello"
        string2 = "hello"

        expect(string === string).to be true
      end

      it "compares equality of a string and an object" do
        class SomeObject
          def to_str
            "some string message"
          end
        end

        expect("here's some string message" === "here's " + SomeObject.new).to be true
      end

      it "demonstrates that to_str is not defined on any objects normally (that I know of at least), but is the default method call for string conversions" do
        class ObjectWithoutToStr
        end

        expect{ combine = "pls " + ObjectWithoutToStr.new }.to raise_error(TypeError, /no implicit conversion of ObjectWithoutToStr into String/)
      end
    end

    describe "string =~ object" do
      it "it returns the index of the string for the first match with a regex" do
        string = "where am I mr. regex?"

        match = string =~ /mr./

        expect(match).to eq(11)
      end

      it "doesn't like integers, sorry" do
        string = "where am I mr. integer?"

        match = string =~ 9

        expect(match).to be nil
      end

      it "...even if there are integers" do
        string = "1234567890"

        match = string =~ 9

        expect(match).to be nil
      end

      it "pukes when it sees a string" do
        string = "where am I mr. capital letter?"

        expect{ match = string =~ "I" }.to raise_error(TypeError,/type mismatch: String given/)
      end
    end
  end

  context "Instance Methods" do
    describe "string[things]" do
      it "finds the value at an index within the string" do
        string = "there's a Whole lot of words in this string."
        index = 10

        string_at_index = string[index]

        expect(string_at_index).to eq("W")
      end

      it "doesn't know what you're talking about when you try to find an index outside of the string" do
        string = "there's a Whole lot of words in this string."
        index = 9001

        string_at_index = string[index]

        expect(string_at_index).to be nil
      end

      it "goes to the back when you give it a negative number" do
        string = "there's a Whole lot of words in this string."
        index = -1

        string_at_index = string[index]

        expect(string_at_index).to eq(".")
      end

      it "will give you back a section if you ask nicely" do
        string = "there's a Whole lot of words in this string."
        index = 10
        length = 5

        string_at_index = string[index, length]

        expect(string_at_index).to eq("Whole")
      end

      it "it speaks different languages for sections as well" do
        string = "there's a Whole lot of words in this string."
        range = (10...15)

        string_at_index = string[range]

        expect(string_at_index).to eq("Whole")
      end

      it "will accept a regex" do
        string = "there's A Whole Lot oF words in this string. ```!"  # note chars with one instance are capitalized
        regex = /(Whole)/        # find all of Whole (subexpression)
        regex01 = /(LOFT)/       # LOFT doesn't exist (subexpression)
        regex02 = /[^there's ]/  # literally -not "there's "- returns what comes after it (exclusive, order dependent)
        regex03 = /[A]/          # finds the character then returns it
        regex04 = /[LAW]/        # finds the first occurence in the set and returns it
        regex05 = /\./           # what's the difference between these two?!
        regex06 = /[']/          # what's the difference between these two?!

        regex07 = /(?<vowel>[aeiou])(?<not_vowel>[^aeiou])/  # finds first match after not-vowel

        ## ..... This has turned into a regex deep-dive.  Aborting for now but will make a regex_spec.rb at some point.
        ## Too interesting not to.

        string_at_index = string[regex]

        expect(string_at_index).to eq("Whole")
        expect(string[regex01]).to be nil
        expect(string[regex02]).to eq("A")
        expect(string[regex03]).to eq("A")
        expect(string[regex04]).to eq("A")
        expect(string[regex05]).to eq(".")
        expect(string[regex06]).to eq("'")
        expect(string[regex07, "not_vowel"]).to eq("r")
      end

      it "will match on strings as well" do
        string = "there's a Whole lot of words in this string."
        match = "Whole"

        string_at_index = string[match]

        expect(string_at_index).to eq("Whole")
      end

      it "but only if they exist" do
        string = "there's a Whole lot of words in this string."
        no_match = "zebra"

        string_at_index = string[no_match]

        expect(string_at_index).to be nil
      end
    end

    describe "string ascii_only?" do
      it "not sure if i care about this right now, might be useful for translations" do
        expect("abc".force_encoding("UTF-8").ascii_only?).to be true
        expect("abc\u{6666}".force_encoding("UTF-8").ascii_only?).to be false
      end
    end

    describe "string.b" do
      it "returns a copied string" do
        string = "string"
        expect(string.b.object_id).not_to eq(string.object_id)
      end

      it "returns a string whose encoding is ASCII-8BIT" do
        encoded_string = "string".encode("UTF-8")

        ascii_string = encoded_string.b

        expect(ascii_string.encoding).to eq(Encoding::ASCII_8BIT)
        expect(encoded_string.encoding).to eq(Encoding::UTF_8)
        expect(encoded_string).not_to be ascii_string   # essentially explains what's going on above but less explicitly
        expect(encoded_string).to eq(ascii_string)      # this works becase the _content_ of each string is the same
      end
    end

    describe "string.bytes" do
      it "returns an array of the bytes of the string" do
        string = "bytes"

        bytes_array = string.bytes

        expect(bytes_array).to be_a(Array)
        expect(bytes_array).to eq([98, 121, 116, 101, 115])
      end

      it "is an alias for .each_byte.to_a, which is a deprecated form" do
        string = "bytes"

        bytes_array = string.each_byte.to_a

        expect(bytes_array).to be_a(Array)
        expect(bytes_array).to eq([98, 121, 116, 101, 115])
      end
    end

    describe "bytesize" do
      it "returns the length in number of bytes" do
        length_5 = "hello"
        expect(length_5.bytesize).to eq(5)
      end

      it "it even does it when it's bytes" do
        byte_string = "\x80\u3042"
        expect(byte_string.bytesize).to eq(4)
      end
    end

    describe "byteslice" do
      it "slices the string on index of bytes" do
        string = "string"

        byte_slice = string.byteslice(1)
        bigger_slice = string.byteslice(3,4)

        expect(byte_slice).to eq("t")
        expect(bigger_slice).to eq("ing")  # not directly sure why this slice reveals 3 chars.  learn more about bytes in strings.
      end

      it "slices the string on index of bytes, if the string is bytes" do
        string = "\x80\u3042"

        byte_slice = string.byteslice(0)
        byte_slice2 = string.byteslice(1,3)

        expect(byte_slice).to eq("\x80")
        expect(byte_slice2).to eq("\u3042")
      end

      it "can use a range as well" do
        string = "\x80\u3042"

        byte_slice = string.byteslice(1..3)

        expect(byte_slice).to eq("\u3042")
      end
    end

    describe "capitalize" do
      it "returns the humanized version of the string with the first letter being capitalized" do
        hello = "hello"
        goodbye = "GOODBYE"
        no_change = "No change"

        expect(hello.capitalize).to eq("Hello")
        expect(goodbye.capitalize).to eq("Goodbye")
        expect(no_change.capitalize).to eq("No change")
      end

      it "capitalize! mutates the original string" do
        unmutated = "unmutated"
        mutated = "mutated"

        unmutated.capitalize
        mutated.capitalize!

        expect(unmutated).to eq("unmutated")
        expect(mutated).to eq("Mutated")
      end

      it "only works within the ASCII region of characters" do
        string = "é"

        expect(string.capitalize).to eq("é")
      end
    end

    describe "casecmp" do
      it "compares strings, ignoring case sensitivity" do
        string = "string"
        string1 = "string1"
        string2 = "StRiNg"
        string3 = "STRING"

        expect(string.casecmp(string1)).to eq(-1)
        expect(string1.casecmp(string)).to eq(1)
        expect(string.casecmp(string2)).to eq(0)
        expect(string.casecmp(string3)).to eq(0)
      end
    end

    describe "center" do
      it "centers a string with desired padding" do
        string = "centered"   # 8 chars long
        under_size = 2        # expect no padding and all letters of string
        odd_size = 11         # 11 - 8 = 3 (adds one space to the right first on odd numbers)
        max_width = 18        # 22 - 8 = 10 (one space on either side)

        under_size_centered_string = string.center(under_size)
        odd_size_centered_string = string.center(odd_size)
        max_centered_string = string.center(max_width)

        expect(under_size_centered_string).to eq("centered")
        expect(odd_size_centered_string).to eq(" centered  ")
        expect(max_centered_string).to eq("     centered     ")
      end

      it "can customize the padding!" do
        string = "custom"    # 6 chars long
        padding_length = 18
        padding_type_1 = "*"
        padding_type_2 = "#"
        padding_type_3 = "^_^"

        string_type_1 = string.center(padding_length, padding_type_1)
        string_type_2 = string.center(padding_length, padding_type_2)
        string_type_3 = string.center(padding_length, padding_type_3)

        expect(string_type_1).to eq("******custom******")
        expect(string_type_2).to eq("######custom######")
        expect(string_type_3).to eq("^_^^_^custom^_^^_^")
      end
    end

    describe "chars" do
      it "returns an Array of characters" do
        string = "string"

        chars = string.chars

        expect(chars).to eq(["s","t","r","i","n","g"])
      end
    end

    describe "chomp" do
      it "removes the last record separator from a string (like \\n for new line)" do
        string = "end of string\n"

        chomped = string.chomp

        expect(chomped).to eq("end of string")
      end

      it "will only remove one of them by default" do
        string = "end of string\n\n"

        chomped = string.chomp

        expect(chomped).to eq("end of string\n")
      end

      it "will only remove two if you ask it to" do
        string = "end of string\n\r\n"

        chomped = string.chomp("\n\r\n")

        expect(chomped).to eq("end of string")
      end

      it "can also take a bigger bite off of the end" do
        string = "end of string\n\n"

        chomped = string.chomp("string\n\n")

        expect(chomped).to eq("end of ")
      end

      it "isn't very smart about how it removes things" do
        string = "end of string\n\r\n"

        chomped = string.chomp("\n\n")

        expect(chomped).to eq("end of string\n\r\n")
      end

      it "unless you give it ('') to chew on" do
        string = "end of string\n\r\n"

        chomped = string.chomp("")

        expect(chomped).to eq("end of string")
      end

      it "chomp! does the same as above but mutates the string" do
        string = "end of string\n\n"

        string.chomp!("")

        expect(string).to eq("end of string")
      end
    end

    describe "chop" do
      it "acts like chomp but more aggressively" do
        string = "string\r\n"

        chopped = string.chop

        expect(chopped).to eq("string")
      end

      it "if you're not careful, you'll cut your finger tips off!" do
        string = "string"

        chopped = string.chop

        expect(chopped).to eq("strin")
      end

      it "will chop at nothing" do
        string = "a"

        chopped = string.chop.chop

        expect(chopped).to eq("")
      end

      it "chop! will also mutate the string" do
        string = "string\r\n"

        string.chop!

        expect(string).to eq("string")
      end
    end

    describe "chr" do
      it "returns a one character string from the beginning of the string provided" do
        hello = "hello"

        character = hello.chr

        expect(character).to eq("h")
      end

      it "if given an empty string it returns an empty string" do
        nothing = ""

        character = nothing.chr

        expect(character).to eq("")
      end
    end

    describe "clear" do
      it "empties the contents of a string" do
        string = "string"

        cleared_string = string.clear

        expect(cleared_string).to eq("")
      end
    end

    describe "codepoints" do
      it "returns an array of integer ordinals" do
        string = "string"

        codepoints = string.codepoints

        expect(codepoints).to eq([115, 116, 114, 105, 110, 103])
      end
    end

    describe "concat" do
      it "appends a string to a string" do
        string = "Original"
        append_me = "Gangster"

        concat = string.concat(append_me)

        expect(concat).to eq("OriginalGangster")
      end

      it "appends an object to a string, if Object.to_str is defined" do
        class SomeObject
          def to_str
            "Gangster"
          end
        end

        string = "Original"
        append_me = SomeObject.new

        concat = string.concat(append_me)

        expect(concat).to eq("OriginalGangster")
      end

      it "may be better known to use << syntax" do
        string = "Original"
        append_me = "Gangster"

        concat = string << append_me

        expect(concat).to eq("OriginalGangster")
      end
    end

    describe "count" do
      it "counts the occurances of chacaters in a string" do
        string = "four"
        look_for = "o"

        counted = string.count(look_for)

        expect(counted).to eq(1)
        expect(string.count("a")).to eq(0)
      end

      it "will count between things" do
        string = "mississauga"
        look_from = "mi"
        look_to = "is"

        counted = string.count(look_from, look_to)

        expect(counted).to eq(2)
      end
    end

    xdescribe "crypt" do
      # makes a cryptographic hash with a salt
    end

    describe "delete" do
      it "removes all the desired value(s) from a string" do
        hello = "hello"

        deleted = hello.delete("l")

        expect(deleted).to eq("heo")
      end

      it "removes a range of chars" do
        hello = "hello"

        deleted = hello.delete("a-z")

        expect(deleted).to eq("")
      end

      it "removes all characters intersecting between the two sets (like String#count)" do
        alphabet = "abcdefg"

        deleted = alphabet.delete("cdef", "defg")
        deleted_2 = alphabet.delete("abcdefg", "^cd")     # lookin' kinda regex-y to me!
        deleted_3 = alphabet.delete("a-z")
        deleted_4 = alphabet.delete("a-z", "^def")        # lookin' kinda regex-y to me!

        expect(deleted).to eq("abcg")
        expect(deleted_2).to eq("cd")
        expect(deleted_3).to eq("")
        expect(deleted_4).to eq("def")
      end

      it "delete! mutates the string in place" do
        hello = "hello"

        hello.delete!("a-z")

        expect(hello).to eq("")
      end
    end

    describe "downcase" do
      it "makes all characters lowercase" do
        upper_case = "WHOAAAAAH!!!"

        lower_case = upper_case.downcase

        expect(lower_case).to eq("whoaaaaah!!!")
      end

      it "downcase! mutates the string in place" do
        upper_case = "WHOAAAAAH!!!"

        upper_case.downcase!

        expect(upper_case).to eq("whoaaaaah!!!")
      end
    end

    describe "dump" do
      it "produces a version of the string with all non-printing characters replaced by \\nnn notation and all special characters escaped." do
        string_with_things = "hello \n ''"

        dumped_string = string_with_things.dump

        expect(dumped_string).to eq("\"hello \\n ''\"")
      end
    end

    describe "each_byte" do
      it "enumerates on each byte of the string" do
        string = "lots of bytes"
        string_bytes = string.bytes

        enumerated = []
        string.each_byte { |b| enumerated << b }

        expect(enumerated).to eq(string_bytes)
      end

      it "returns an enumerator object if empty" do
        string = "lots of bytes"

        enumerated = string.each_byte

        expect(enumerated).to be_a(Enumerator)
      end
    end

    describe "each_char" do
      it "enumerates on each character of the string" do
        string = "lots of characters"
        string_array = string.split('')

        enumerated = []
        string.each_char { |c| enumerated << c }

        expect(enumerated).to eq(string_array)
      end

      it "returns an enumerator object if empty" do
        string = "lots of characters"

        enumerated = string.each_char

        expect(enumerated).to be_a(Enumerator)
      end
    end

    describe "each_codepoint" do
      it "enumerates on each character of the string as an ordinal" do
        string = "lots of characters"
        ordinal_array = string.split('').map.each { |c| c = c.ord }

        enumerated = []
        string.each_codepoint { |c| enumerated << c }

        expect(enumerated).to eq(ordinal_array)
      end

      it "returns an enumerator object if empty" do
        string = "lots of characters"

        enumerated = string.each_codepoint

        expect(enumerated).to be_a(Enumerator)
      end
    end

    describe "each_line" do
      it "enumerates on each new line of the string" do
        string = "lots\nof\nnew\nlines"

        enumerated = []
        string.each_line { |new_line| enumerated << new_line }

        expect(enumerated).to eq(["lots\n", "of\n", "new\n", "lines"])
      end

      it "returns an enumerator object if empty" do
        string = "lots\nof\nnew\nlines"

        enumerated = string.each_line

        expect(enumerated).to be_a(Enumerator)
      end
    end

    describe "empty?" do
      it "returns true if a string is empty" do
        string = ""

        is_it_empty = string.empty?

        expect(is_it_empty).to be true
      end

      it "returns false if a string is not empty" do
        string = "i'm not empty!"

        is_it_empty = string.empty?

        expect(is_it_empty).to be false
      end
    end

    xdescribe "encode" do
      # encodes things and gives you information about it
    end

    describe "encoding" do
      it "returns the Encoding type" do
        utf_8_string = "I'm UTF-8!".force_encoding(Encoding::UTF_8)
        expect(utf_8_string.encoding).to be Encoding::UTF_8
      end
    end

    describe "end_with?" do
      it "returns true if the string ends with the value provided" do
        string = "string"

        match = string.end_with?("ing")

        expect(match).to be true
      end

      it "returns false if the string does not end with the value provided" do
        string = "string"

        match = string.end_with?("bees")

        expect(match).to be false
      end

      it "accepts multiple suffixes and returns true if one or more matches" do
        string = "string"

        match = string.end_with?("bees", "honey", "ing", "ng", "g")

        expect(match).to be true
      end

      it "accepts multiple suffixes and returns false if none match" do
        string = "string"

        match = string.end_with?("bees", "honey", "bear")

        expect(match).to be false
      end
    end

    describe "eql?" do
      it "determines if two strings are equal by length and content" do
        string1 = "string"
        string2 = "string"

        match = string1.eql?(string2)

        expect(match).to be true
      end

      it "tells you if they aren't" do
        string1 = "string"
        string2 = "string "

        match = string1.eql?(string2)

        expect(match).to be false
      end

      it "case sensitivity matters here" do
        string1 = "string"
        string2 = "STRING"

        match = string1.eql?(string2)

        expect(match).to be false
      end
    end

    describe "force_encoding" do
      it "forces the encoding of a string to be of type specified" do
        utf_8_string = "i'm UTF-8".force_encoding("UTF-8")
        ascii_string = "i'm ASCII".force_encoding("ASCII-8BIT")

        expect(utf_8_string.encoding).to be Encoding::UTF_8
        expect(ascii_string.encoding).to be Encoding::ASCII_8BIT
      end
    end

    describe "freeze" do
      it "prevents strings from being modified" do
        string = "freeze me"

        expect(string.frozen?).to be false

        frozen_string = string.freeze

        expect{ frozen_string << " <ice pick;;;==O" }.to raise_error(RuntimeError, /can't modify frozen String/)
      end

      it "does not prevent strings from being modified if they are reassigned" do
        string = "freeze me"

        expect(string.frozen?).to be false

        frozen_string = string.freeze
        frozen_string = "i've thawed"

        expect(frozen_string << " <ice pick;;;==O").to eq("i've thawed <ice pick;;;==O")
      end
    end

    describe "getbyte" do
      it "returns the indexth byte as an integer" do
        string = "string"
        byte_value = "t".bytes.first

        byteiger = string.getbyte(1)

        expect(byteiger).to eq(116)
        expect(byteiger).to eq(byte_value)
      end
    end

    describe "gsub" do
      it "does a regular expression search and replace on the string" do
        ## not going to dive deep into regex here, that's being saved for another spec
        string = "I need a coffee"

        subbed_string = string.gsub(/(coffee)/, "large coffee")

        expect(subbed_string).to eq("I need a large coffee")
      end

      it "returns the original string when there is no match" do
        ## not going to dive deep into regex here, that's being saved for another spec
        string = "I need a coffee"

        subbed_string = string.gsub(/[z]/, "large coffee")

        expect(subbed_string).to eq("I need a coffee")
      end

      it "gsub! mutates the string in place" do
        ## not going to dive deep into regex here, that's being saved for another spec
        string = "I need a coffee"

        string.gsub!(/(coffee)/, "large coffee")

        expect(string).to eq("I need a large coffee")
      end

      it "can use a hash to replace vaules" do
        ## not going to dive deep into regex here, that's being saved for another spec
        string = "I need a coffee"

        subbed_string = string.gsub(/(need)|(coffee)/, "need" => "really need", "coffee" => "large coffee")

        expect(subbed_string).to eq("I really need a large coffee")
      end
    end

    describe "hash" do
      it "returns a hash based on the strings content, length and encoding" do
        math_hash = "string".hash       #  these ain't your key-value pair kind hashes
        math_hash2 = "string".hash

        expect(math_hash).to be_a(Fixnum)
        expect(math_hash == math_hash2).to be true
        expect(math_hash <=> math_hash2).to eq(0)
      end
    end

    describe "hex" do
      it "converts a 'hex' string into an integer" do
        hex_string_representation = "0x08"
        hex_string_representation1 = "08"
        hex_string_representation2 = "0xaf"

        integer = hex_string_representation.hex
        integer1 = hex_string_representation1.hex
        integer2 = hex_string_representation2.hex

        expect(integer).to eq(8)
        expect(integer1).to eq(8)
        expect(integer2).to eq(175)
      end
    end

    describe "include?" do
      it "returns true if it includes the specified values" do
        string = "abcdefghijklmnopqrstuvwxyz"

        match = string.include?("a")
        match2 = string.include?("ab")
        match3 = string.include?("mnopqrst")

        expect(match).to be true
        expect(match2).to be true
        expect(match3).to be true
      end

      it "returns false if it does not include the specified values exactly as stated" do
        string = "abcdefghijklmnopqrstuvwxyz"
        reverse_string = string.reverse         # "zyxwvutsrqponmlkjihgfedcba"

        match = string.include?("ace")
        match2 = string.include?(reverse_string)

        expect(match).to be false
        expect(match2).to be false
      end
    end

    describe "index" do
      it "returns the index of the first occurance of a given substring" do
        string = "index at '10' will return 10"           # see what I did there?
        substring = "10"

        index_value = string.index(substring)

        expect(index_value).to eq(10)
      end

      it "returns the index of the first occurance of a given substring with an offset of whatever is specified" do
        string = "index at '10' will return 10"           # see what I did there?
        substring = "10"
        offset = 1
        offset2 = 11

        index_value = string.index(substring, offset)     # offset from root index still falls BEFORE first occurrence of 10
        index_value2 = string.index(substring, offset2)   # offset from root index falls falls AFTER first occurence of 10

        expect(index_value).to eq(10)
        expect(index_value2).to eq(26)                    # ignores the first 10 because of the offset
      end

      it "returns the index of the first occurance of a given /regular expression/" do
        string = "index at '10' will return 10"           # see what I did there?
        regex = /(10)/

        index_value = string.index(regex)

        expect(index_value).to eq(10)
      end
    end

    describe "replace" do
      it "replaces the contents of one string with another by mutating the caller" do
        string = "this is all going to go bye-bye"
        replacement = "a"

        string.replace(replacement)

        expect(string).to eq("a")
      end
    end

    describe "insert" do
      it "inserts a string at the index location of the caller string" do
        string = "sub something in between these __ things"
        index = string.index("__") + 1
        inserted_string = "gopher"

        string.insert(index, inserted_string)

        expect(string).to eq("sub something in between these _gopher_ things")
      end
    end

    describe "inspect" do
      it "returns a printable version of string, surrounded by quites and with special chars escaped" do
        string = "this string that you see\nis a bad kind of haiku\ni'm still not famous"

        inspected_string = string.inspect

        expect(inspected_string).to eq("\"this string that you see\\nis a bad kind of haiku\\ni'm still not famous\"")
      end
    end

    describe "intern" do
      it "creates an associated symbol from the given string" do
        string = "new_symbol"

        intern = string.intern

        expect(intern).to be_a(Symbol)
        expect(intern).to be :new_symbol
      end

      it "can create a symbol that has weird characters like :'this and that'" do
        string = "this and that"

        intern = string.intern

        expect(intern).to be_a(Symbol)
        expect(intern).to be :'this and that'
      end
    end

    describe "length" do
      it "returns the length of the string as an integer" do
        string = "length"

        length = string.length

        expect(length).to be_a(Fixnum)
        expect(length).to eq(6)
      end

      it "returns the length of the string as an integer even with escaped chars" do
        string = "length\n\r\n"

        length = string.length

        expect(length).to be_a(Fixnum)
        expect(length).to eq(9)
      end
    end

    describe "lines" do
      it "is a short-hand for String#each_line.to_a" do
        string = "lots\nof\nnew\nlines"

        enumerated = []
        string.lines { |new_line| enumerated << new_line }

        expect(enumerated).to eq(["lots\n", "of\n", "new\n", "lines"])
      end

      it "returns an Array object if no block is given" do
        string = "lots\nof\nnew\nlines"

        enumerated = string.lines

        expect(enumerated).to be_a(Array)
        expect(enumerated).to eq(["lots\n", "of\n", "new\n", "lines"])
      end
    end

    describe "ljust (left justify)" do
      it "adds characters to the right of the string" do
        string = "string"

        ljust_string = string.ljust(4)
        ljust_string1 = string.ljust(7)
        ljust_string2 = string.ljust(10)

        expect(ljust_string).to eq("string")
        expect(ljust_string1).to eq("string ")
        expect(ljust_string2).to eq("string    ")
      end

      it "adds characters to the right of the string" do
        string = "string"
        ljust_type = "*"

        ljust_string = string.ljust(10, ljust_type)

        expect(ljust_string).to eq("string****")
      end
    end

    describe "lstrp (left strip)" do
      it "strips the white space from the left side of a string" do
        string_with_whitespace = "          string  "

        string = string_with_whitespace.lstrip

        expect(string).to eq("string  ")
      end

      it "lstrip! mutates the string in place" do
        string_with_whitespace = "          string  "

        string_with_whitespace.lstrip!

        expect(string_with_whitespace).to eq("string  ")
      end
    end

    describe "match" do
      it "matches on a regex and returns a MatchData object" do
        string = "find the regex in this string"

        match = string.match(/(regex)/)

        expect(match).to be_a(MatchData)
        expect(match.captures).to include("regex")
        expect(match.regexp).to eq(/(regex)/)
        expect(match.post_match).to eq(" in this string")
        expect(match.to_s).to eq("regex")
      end

      it "matches on a regex and returns a MatchData object" do
        string = "find the regex in this string"

        match = string.match(/(missing)/)

        expect(match).to be nil
      end
    end

    describe "next && succ" do
      it "increases the byte value of the last alphanumeric character by one" do
        string = "string"
        string_byte_value = string.bytes

        next_value = string.next
        next_byte_value = next_value.bytes
        byte_value_change = string_byte_value.last + 1

        expect(next_value).to eq("strinh")
        expect(next_byte_value.last).to eq(byte_value_change)
      end

      it "nest is an alias for succ" do
        string = "string"
        string_byte_value = string.bytes

        succ_value = string.succ
        succ_byte_value = succ_value.bytes
        byte_value_change = string_byte_value.last + 1

        expect(succ_value).to eq("strinh")
        expect(succ_byte_value.last).to eq(byte_value_change)
      end

      it "operates the same on number-strings" do
        number_string = "12345"

        next_value = number_string.next

        expect(next_value).to eq("12346")
      end

      it "next! && succ! mutate the string in place" do
        number_string = "12345"

        number_string.next!

        expect(number_string).to eq("12346")
      end
    end

    describe "oct" do
      it "takes a string of numbers and returns its octal representation" do
        number_string = "567"

        octal = number_string.oct

        expect(octal).to be_a(Fixnum)
        expect(octal).to eq(375)
      end

      it "returns 0 for strings of characters" do
        character_string = "abcd"

        octal = character_string.oct

        expect(octal).to be_a(Fixnum)
        expect(octal).to eq(0)
      end

      it "carries negative values" do
        number_string = "-567"

        octal = number_string.oct

        expect(octal).to be_a(Fixnum)
        expect(octal).to eq(-375)
      end

      it "only pays attention to numbers if characters are present" do
        char_number_string = "567def"

        octal = char_number_string.oct

        expect(octal).to be_a(Fixnum)
        expect(octal).to eq(375)
      end

      it "checks from left to right for numbers and acts accordingly" do
        char_number_string = "abc567def"

        octal = char_number_string.oct

        expect(octal).to be_a(Fixnum)
        expect(octal).to eq(0)
      end
    end

    describe "ord" do
      it "returns the integer ordinal of a one character string" do
        one_char_string = "O"

        ordinal = one_char_string.ord

        expect(ordinal).to eq(79)
      end

      it "returns the integer ordinal of the first character in the string, only" do
        two_char_string = "OG"

        ordinal = two_char_string.ord

        expect(ordinal).to eq(79)
      end
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
end
