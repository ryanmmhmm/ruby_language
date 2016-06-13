require 'ruby_string'

RSpec.describe RubyString do
  context "Public Methods" do
    describe ".new" do
      it "creates a new instance of string" do
        string1 = String.new
        string2 = String.new

        expect(string1.object_id).not_to eq(string2.object_id)
      end
    end

    describe ".try_convert" do
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
    describe "'string' \% argument" do
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

    describe "'string' * integer" do
      it "multiplies the content of a string" do
        string = "Three"

        string_multiplier = string * 3

        expect(string_multiplier).to eq("ThreeThreeThree")
      end
    end

    describe "'string' + other_string" do
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

    describe "'string' << " do
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

    describe "'string' <=> (saucer operator)" do
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

    describe "'string' == object" do
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

    describe "'string' === object" do
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

    describe "'string' =~ object" do
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

    describe "String#b" do
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

    describe "String#bytes" do
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

    describe "String#bytesize" do
      it "returns the length in number of bytes" do
        length_5 = "hello"
        expect(length_5.bytesize).to eq(5)
      end

      it "it even does it when it's bytes" do
        byte_string = "\x80\u3042"
        expect(byte_string.bytesize).to eq(4)
      end
    end

    describe "String#byteslice" do
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

    describe "String#capitalize" do
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

    describe "String#casecmp" do
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

    describe "String#center" do
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

    describe "String#chars" do
      it "returns an Array of characters" do
        string = "string"

        chars = string.chars

        expect(chars).to eq(["s","t","r","i","n","g"])
      end
    end

    describe "String#chomp" do
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

    describe "String#chop" do
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

    describe "String#chr" do
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

    describe "String#clear" do
      it "empties the contents of a string" do
        string = "string"

        cleared_string = string.clear

        expect(cleared_string).to eq("")
      end
    end

    describe "String#codepoints" do
      it "returns an array of integer ordinals" do
        string = "string"

        codepoints = string.codepoints

        expect(codepoints).to eq([115, 116, 114, 105, 110, 103])
      end
    end

    describe "String#concat" do
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

    describe "String#count" do
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

    xdescribe "String#crypt" do
      # makes a cryptographic hash with a salt
    end

    describe "String#delete" do
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

    describe "String#downcase" do
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

    describe "String#dump" do
      it "produces a version of the string with all non-printing characters replaced by \\nnn notation and all special characters escaped." do
        string_with_things = "hello \n ''"

        dumped_string = string_with_things.dump

        expect(dumped_string).to eq("\"hello \\n ''\"")
      end
    end

    describe "String#each_byte" do
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

    describe "String#each_char" do
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

    describe "String#each_codepoint" do
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

    describe "String#each_line" do
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

    describe "String#empty?" do
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

    describe "String#encode" do
      it "changes the encoding of a string " do
        string = "this is a string"

        from_encoding = "UTF-8"
        to_encoding = "ASCII-8BIT"

        new_encoding = string.encode(to_encoding, from_encoding)

        expect(string.encoding).to be Encoding::UTF_8
        expect(new_encoding.encoding).to be Encoding::ASCII_8BIT
      end

      it "can do this short-hand by just naming the destination encoding" do
        string = "this is a string"

        to_encoding = "ASCII-8BIT"

        new_encoding = string.encode(to_encoding)

        expect(string.encoding).to be Encoding::UTF_8
        expect(new_encoding.encoding).to be Encoding::ASCII_8BIT
      end

      it "will change the bytes within a string according to an encoding map" do
        string = "Código Descrição Cliente Família"

        new_encoding = string.encode(Encoding::ISO8859_15)

        expect(string.bytes).to eq([67, 195, 179, 100, 105, 103, 111, 32, 68, 101, 115, 99, 114, 105, 195, 167, 195, 163, 111, 32, 67, 108, 105, 101, 110, 116, 101, 32, 70, 97, 109, 195, 173, 108, 105, 97])
        expect(new_encoding.bytes).to eq([67, 243, 100, 105, 103, 111, 32, 68, 101, 115, 99, 114, 105, 231, 227, 111, 32, 67, 108, 105, 101, 110, 116, 101, 32, 70, 97, 109, 237, 108, 105, 97])
        expect(new_encoding.encoding).to be Encoding::ISO8859_15
        expect(new_encoding.dump).to eq("C\xF3digo Descri\xE7\xE3o Cliente Fam\xEDlia".dump)
      end

      it "will throw an error if characters do not map correctly" do
        unmapped_in_ascii = "¯¯¯"

        expect{ unmapped_in_ascii.encode(Encoding::ASCII_8BIT) }.to raise_error(Encoding::UndefinedConversionError, /from UTF-8 to ASCII-8BIT/)
      end

      it "can replace undefined characters with a specified character" do
        unmapped_in_ascii = "¯¯¯"

        replace_unmapped = unmapped_in_ascii.encode(Encoding::ASCII_8BIT, undef: :replace, replace: "-")

        expect(replace_unmapped).to eq("---")
      end

      it "another example of an undefined character replaced with a specified character" do
        unmapped_in_ISO_8859_15 = "ʕʕʕ"

        replace_unmapped = unmapped_in_ISO_8859_15.encode(Encoding::ISO8859_15, undef: :replace, replace: "-")

        expect(replace_unmapped).to eq("---")
      end
    end

    describe "String#encoding" do
      it "returns the Encoding type" do
        utf_8_string = "I'm UTF-8!".force_encoding(Encoding::UTF_8)
        expect(utf_8_string.encoding).to be Encoding::UTF_8
      end
    end

    describe "String#end_with?" do
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

    describe "String#eql?" do
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

    describe "String#force_encoding" do
      it "forces the encoding of a string to be of type specified" do
        utf_8_string = "i'm UTF-8".force_encoding("UTF-8")
        ascii_string = "i'm ASCII".force_encoding("ASCII-8BIT")

        expect(utf_8_string.encoding).to be Encoding::UTF_8
        expect(ascii_string.encoding).to be Encoding::ASCII_8BIT
      end
    end

    describe "String#freeze" do
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

    describe "String#getbyte" do
      it "returns the indexth byte as an integer" do
        string = "string"
        byte_value = "t".bytes.first

        byteiger = string.getbyte(1)

        expect(byteiger).to eq(116)
        expect(byteiger).to eq(byte_value)
      end
    end

    describe "String#gsub" do
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

    describe "String#hash" do
      it "returns a hash based on the strings content, length and encoding" do
        math_hash = "string".hash       #  these ain't your key-value pair kind hashes
        math_hash2 = "string".hash

        expect(math_hash).to be_a(Fixnum)
        expect(math_hash == math_hash2).to be true
        expect(math_hash <=> math_hash2).to eq(0)
      end
    end

    describe "String#hex" do
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

    describe "String#include?" do
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

    describe "String#index" do
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

    describe "String#replace" do
      it "replaces the contents of one string with another by mutating the caller" do
        string = "this is all going to go bye-bye"
        replacement = "a"

        string.replace(replacement)

        expect(string).to eq("a")
      end
    end

    describe "String#insert" do
      it "inserts a string at the index location of the caller string" do
        string = "sub something in between these __ things"
        index = string.index("__") + 1
        inserted_string = "gopher"

        string.insert(index, inserted_string)

        expect(string).to eq("sub something in between these _gopher_ things")
      end
    end

    describe "String#inspect" do
      it "returns a printable version of string, surrounded by quites and with special chars escaped" do
        string = "this string that you see\nis a bad kind of haiku\ni'm still not famous"

        inspected_string = string.inspect

        expect(inspected_string).to eq("\"this string that you see\\nis a bad kind of haiku\\ni'm still not famous\"")
      end
    end

    describe "String#intern" do
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

    describe "String#length" do
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

    describe "String#lines" do
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

    describe "String#ljust (left justify)" do
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

    describe "String#lstrp (left strip)" do
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

    describe "String#match" do
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

    describe "String$#next && #succ" do
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

    describe "String#oct" do
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

    describe "String#ord" do
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

    describe "String#partition" do
      it "returns an array split on the specified character, returning before, the match, and after" do
        string = "split me"

        partitioned = string.partition(" ")

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["split", " ", "me"])
      end

      it "returns '' for match and after if the char isn't included in the string" do
        string = "split me"

        partitioned = string.partition("x")

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["split me", "", ""])
      end

      it "accepts a regex as an argument" do
        string = "split me"

        partitioned = string.partition(/(it)/)

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["spl", "it", " me"])
      end
    end

    describe "String#prepend" do
      it "adds the given string to the front of the desired string by mutating it" do
        string = "prepend me"

        string.prepend("please ")

        expect(string).to eq("please prepend me")
      end
    end

    describe "String#replace" do
      it "replaces the contents of a string with the contents of the desired string, and mutates it in place" do
        string = "hello"

        string.replace("goodbye")

        expect(string).to eq("goodbye")
      end
    end

    describe "String#reverse" do
      it "reverses the contents of the string" do
        string = "reverse me"

        reversed = string.reverse

        expect(reversed).to eq("em esrever")
      end

      it "reverse! mutates the contents in place" do
        string = "reverse me"

        reversed = string.reverse

        expect(reversed).to eq("em esrever")
      end
    end

    describe "String#rindex" do
      it "returns the index of the _last_ occurrence of the given substring" do
        string = "the quick brown fox jumps over the lazy dog."
        substring = "."

        rindex = string.rindex(substring)

        expect(string.length).to eq(44)
        expect(rindex).to be_a(Fixnum)
        expect(rindex).to eq(43)

      end

      it "returns the index of the _last_ occurrence of the given regex" do
        string = "the quick brown fox jumps over the la_zy dog."
        regex = /[a]/

        rindex = string.rindex(regex)

        expect(rindex).to be_a(Fixnum)
        expect(rindex).to eq(36)
      end

      it "returns nil if the match is not found" do
        string = "the quick brown fox jumps over the lazy dog."
        regex = /[Z]/

        rindex = string.rindex(regex)

        expect(rindex).to be nil
      end

      it "returns the index of the _last_ occurrence of the given regex, with an offset from string[#]" do
        string = "the quick brown fox jumps over the lazy dog."
        regex = /[.]/
        offset = -5

        rindex = string.rindex(regex, offset)

        expect(rindex).to be nil
        expect(offset).to be_a(Fixnum)
      end
    end

    describe "String#rjust" do
      it "adds characters to the left of the string" do
        string = "string"

        rjust_string = string.rjust(4)
        rjust_string1 = string.rjust(7)
        rjust_string2 = string.rjust(10)

        expect(rjust_string).to eq("string")
        expect(rjust_string1).to eq(" string")
        expect(rjust_string2).to eq("    string")
      end

      it "adds characters to the right of the string" do
        string = "string"
        rjust_type = "*"

        rjust_string = string.rjust(10, rjust_type)

        expect(rjust_string).to eq("****string")
      end
    end

    describe "String#rpartition" do
      it "starting from the right of the string, it returns an array split on the specified character, returning before, the match, and after" do
        string = "right split me"

        partitioned = string.rpartition(" ")

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["right split", " ", "me"])
      end

      it "returns '' for match and after if the char isn't included in the string" do
        string = "right split me"

        partitioned = string.rpartition("x")

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["", "", "right split me"])
      end

      it "accepts a regex as an argument" do
        string = "right split me"

        partitioned = string.rpartition(/(split)/)

        expect(partitioned).to be_a(Array)
        expect(partitioned).to eq(["right ", "split", " me"])
      end
    end

    describe "String#rstrip" do
      it "removes the white space from the right side of a string" do
        string_with_whitespace = "string      "

        stripped = string_with_whitespace.rstrip

        expect(stripped).to eq("string")
      end

      it "doesn't remove any whitespace on the left side of the chars" do
        string_with_whitespace = "   string      "

        stripped = string_with_whitespace.rstrip

        expect(stripped).to eq("   string")
      end
    end

    describe "String#scan" do
      it "scans the string for a matched pattern and returns an array broken into groups" do
        string = "the quick brown fox jumps over the lazy dog."

        scanned = string.scan(/\w+/)        # match on every word

        expect(scanned).to eq(["the", "quick", "brown", "fox", "jumps", "over", "the", "lazy", "dog"])
      end

      it "scans is highly customizable" do
        string = "the quick brown fox jumps over the lazy dog."

        scanned = string.scan(/..../)       # 4 * . == 4 character chunks

        expect(scanned).to eq(["the ", "quic", "k br", "own ", "fox ", "jump", "s ov", "er t", "he l", "azy ", "dog."])
      end

      it "sub-groups are returned as nested arrays" do
        string = "the quick brown fox jumps over the lazy dog."

        scanned = string.scan(/(..)(..)/)    # 2 * . == 2 character chunks X 2 per grouping

        expect(scanned).to eq([["th", "e "], ["qu", "ic"], ["k ","br"], ["ow","n "], ["fo","x "], ["ju","mp"], ["s ","ov"], ["er"," t"], ["he"," l"], ["az","y "], ["do","g."]])
      end
    end

    describe "String#scrub" do
      ## more complex byte stuff that i still need to learn, taking this verbatim from docs
      it "replaces invalid bytes with desired replacement character" do
        invalid_byte_string = "abc\u3042\x81"

        scrubbed = invalid_byte_string.scrub

        expect(scrubbed).to eq("abc\u3042\uFFFD")
      end

      it "scrub! mutates string in place, replaces invalid bytes with desired replacement character" do
        invalid_byte_string = "abc\u3042\x81"

        invalid_byte_string.scrub!

        expect(invalid_byte_string).to eq("abc\u3042\uFFFD")
      end
    end

    describe "String#setbyte" do
      it "sets the desired byte at string[index] by integer value" do
        a = "a"
        a.bytes     #=> [97]
        "b".bytes   #=> [98]

        a.setbyte(0,98)

        expect(a).to eq("b")
      end
    end

    describe "String#slice" do
      it "pulls a character from the string at string[index]" do
        string = "string"

        sliced = string.slice(3)

        expect(sliced).to eq("i")
        expect(string).to eq("string")
      end

      it "can be given a start and end index position" do
        string = "string"
        beginning = 1
        ending = 4

        sliced = string.slice(beginning, ending)

        expect(sliced).to eq("trin")
      end

      it "can be given a range" do
        string = "string"
        range = (1..4)

        sliced = string.slice(range)

        expect(sliced).to eq("trin")
      end

      it "can be given a regex" do
        string = "string"
        regex = /(trin)/

        sliced = string.slice(regex)

        expect(sliced).to eq("trin")
      end

      it "can be given a regex and capture value" do
        string = "string"
        regex = /[aeiou](.)/
        capture = 0
        capture2 = 1

        sliced = string.slice(regex, capture)
        sliced_2 = string.slice(regex, capture2)

        expect(sliced).to eq("in")
        expect(sliced_2).to eq("n")
      end

      it "can be given matcher string" do
        string = "string"
        regex = "trin"

        sliced = string.slice(regex)

        expect(sliced).to eq("trin")
      end

      it "returns nil if the match isn't found" do
        string = "string"

        sliced = string.slice(30)

        expect(sliced).to be nil
      end

      it "slice! mutates the string in place and returns the string with the match removed" do
        string = "string"
        regex = /(trin)/

        string.slice!(regex)

        expect(string).to eq("sg")
      end
    end

    describe "String#split" do
      it "breaks up a string based on the pattern supplied and returns an array" do
        string = "here are chars"

        splitsville = string.split(" ")

        expect(splitsville).to be_a(Array)
        expect(splitsville).to eq(["here", "are", "chars"])
      end

      it "can match on a group of chars defined by a string" do
        string = "here are chars"

        splitsville = string.split("re")

        expect(splitsville).to be_a(Array)
        expect(splitsville).to eq(["he", " a", " chars"])
      end

      it "can split a string into an array of individual chars" do
        string = "here are chars"
        array = []
        string.each_char { |c| array << c }

        splitsville = string.split("")

        expect(splitsville).to be_a(Array)
        expect(splitsville).to eq(array)
      end

      it "can split based on regex patterns, with the split occuring where the pattern matches" do
        string = "here are chars"

        splitsville = string.split(/[aeiou]/)
        splitsville2 = string.split(/[^aeiou]/)

        expect(splitsville).to be_a(Array)
        expect(splitsville).to eq(["h", "r", " ", "r", " ch", "rs"])
        expect(splitsville2).to eq(["", "e", "e", "a", "e", "", "", "a"])       # there's a nuance here with the returns for "", explore this
      end

      it "can limit the number of splits based on a provided limiter" do
        string = "here are chars"
        limiter = 3         # makes three groups of strings

        splitsville = string.split(/[aeiou]/, limiter)

        expect(splitsville).to be_a(Array)
        expect(splitsville).to eq(["h", "r", " are chars"])
      end

      it "returns an empty array if the caller is empty" do
        string = ""

        splitsville = string.split("_Z_")

        expect(splitsville).to be_a(Array)
        expect(splitsville).to be_empty
      end
    end

    describe "String#squeeze" do
      it "reduces multiple sequential characters to single characters" do
        string = "lllllooooollllll"

        squeezed = string.squeeze

        expect(squeezed).to eq("lol")
      end

      it "reduces multiple sequential characters to single characters, but only for ones specified" do
        string = "lllllooooollllll"
        selected = "o"

        squeezed = string.squeeze(selected)

        expect(squeezed).to eq("lllllollllll")
      end

      it "can act on a range of supplied letters" do
        alphabet = "abcdefghijklmnopqrstuvwxyz"

        stutter_alphabet = alphabet.chars.each_with_object([]) { |c, memo| memo << c * 2  }.join("")
        squeezed = stutter_alphabet.squeeze("a-z")

        expect(stutter_alphabet).to eq("aabbccddeeffgghhiijjkkllmmnnooppqqrrssttuuvvwwxxyyzz")
        expect(squeezed).to eq(alphabet)
      end

      it "squeeze! mutates the string in place" do
        string = "lllllooooollllll"

        string.squeeze!

        expect(string).to eq("lol")
      end
    end

    describe "String#start_with?" do
      it "returns true if the string starts with any of the provided prefixes" do
        string = "string"
        prefix = "str"
        prefix1 = "st"
        prefix2 = "not a match"

        start_with = string.start_with?(prefix, prefix1, prefix2)

        expect(start_with).to be true
      end

      it "returns false if the string does not start with any of the provided prefixes" do
        string = "string"
        prefix = "a"
        prefix1 = "b"
        prefix2 = "c"

        start_with = string.start_with?(prefix, prefix1, prefix2)

        expect(start_with).to be false
      end
    end

    describe "String#strip" do
      it "removes all whitespace surrounding characters in the string" do
        string_with_whitespace = "   string   "

        stripped = string_with_whitespace.strip

        expect(stripped).to eq("string")
      end

      it "whitespace includes null, horizontal tab, line feed, vertical tab, form feed, carriage return and spaces" do
        string_with_whitespace = "\t\n\v\f\rstring\x00\t\n\v\f\r "

        stripped = string_with_whitespace.strip

        expect(stripped).to eq("string")
      end

      it "strip! mutates the string in place" do
        string_with_whitespace = "\t\n\v\f\rstring\x00\t\n\v\f\r "

        string_with_whitespace.strip!

        expect(string_with_whitespace).to eq("string")
      end
    end

    describe "String#sub" do
      it "substitutes the value provided into the string into the _FIRST_ corresponding match point" do
        string = "theres a lot of subtitution points in here"
        matcher = " "
        substitution = "8"

        substituted = string.sub(matcher, substitution)

        expect(substituted).to eq("theres8a lot of subtitution points in here")
      end

      it "accpets a regex as the matcher" do
        string = "theres a lot of subtitution points in here"
        matcher = /(lot of subtitution points)/
        substitution = "new string"

        substituted = string.sub(matcher, substitution)

        expect(substituted).to eq("theres a new string in here")
      end

      it "if there is no match, it returns the original string" do
        string = "theres a lot of subtitution points in here"
        matcher = "Z"
        substitution = "8"

        substituted = string.sub(matcher, substitution)

        expect(substituted).to eq("theres a lot of subtitution points in here")
      end

      it "sub! mutates the string in place" do
        string = "theres a lot of subtitution points in here"
        matcher = "Z"
        substitution = "8"

        string.sub!(matcher, substitution)

        expect(string).to eq("theres a lot of subtitution points in here")
      end

      it "sub! if there is no match, it returns the original string" do
        string = "theres a lot of subtitution points in here"
        matcher = "Z"
        substitution = "8"

        string.sub!(matcher, substitution)

        expect(string).to eq("theres a lot of subtitution points in here")
      end
    end

    describe "String#succ" do
      #  see 'describe "String#next" do'
    end

    describe "String#sum" do
      it "returns the sum of the binary value of each byte" do
        string = "string"

        sum = string.sum

        expect(sum).to be_a(Integer)
        expect(sum).to eq(663)
      end
    end

    describe "String#swapcase" do
      it "literally swaps the case of each character from up to down or down to up" do
        string = "UP down"

        swapped = string.swapcase

        expect(swapped).to eq("up DOWN")
      end

      it "String#swapcase! mutates the string in place" do
        string = "UP down"

        string.swapcase!

        expect(string).to eq("up DOWN")
      end
    end

    describe "String#to_c" do
      it "converts the string's implicit value to a complex number" do
        number_string = "9001"

        conversion = number_string.to_c

        expect(conversion).to be_a(Complex)
        expect(conversion).to eq(Complex.polar(9001))
        expect(conversion).to eq(Complex.rect(9001))
      end

      it "returns a complex 0 for a junk conversion" do
        string = "string"

        conversion = string.to_c

        expect(conversion).to be_a(Complex)
        expect(conversion).to eq(Complex.polar(0))
        expect(conversion).to eq(Complex.rect(0))
      end
    end

    describe "String#to_f" do
      it "converts the string's implicit value to a floating point number" do
        number_string = "12345.6789"

        conversion = number_string.to_f

        expect(conversion).to be_a(Float)
        expect(conversion).to eq(12345.6789)
      end

      it "returns 0.0 for a junk conversion" do
        string = "H4X0R"

        conversion = string.to_f

        expect(conversion).to be_a(Float)
        expect(conversion).to eq(0.0)
      end

      it "takes in the numbers before the string becomes junk" do
        string = "1337H4X0R"

        conversion = string.to_f

        expect(conversion).to be_a(Float)
        expect(conversion).to eq(1337.0)
      end
    end

    describe "String#to_i" do
      it "converts the string's implicit value to a floating point number" do
        number_string = "12345.6789"

        conversion = number_string.to_i

        expect(conversion).to be_a(Integer)
        expect(conversion).to eq(12345)
      end

      it "will create output for bases 2-36, as long as the caller is of that base" do
        number_string = "101"

        conversion = number_string.to_i(2)

        expect(conversion).to be_a(Integer)
        expect(conversion).to eq(5)
      end

      it "returns 0 for a junk conversion" do
        number_string = "number string"

        conversion = number_string.to_i

        expect(conversion).to be_a(Integer)
        expect(conversion).to eq(0)
      end

      it "will convert string-integer values at the beginning of a string" do
        number_string = "1234string"

        conversion = number_string.to_i

        expect(conversion).to be_a(Integer)
        expect(conversion).to eq(1234)
      end
    end

    describe "String#to_r" do
      it "converts the strings implicit value to a rational number" do
        rational_string = "100/5"

        conversion = rational_string.to_r

        expect(conversion).to be_a(Rational)
        expect(conversion).to eq(100/5)
      end

      it "ignores junk if the leading characters are numbers" do
        rational_string = "100/5asdfasdfasdf"

        conversion = rational_string.to_r

        expect(conversion).to be_a(Rational)
        expect(conversion).to eq(100/5)
      end

      it "returns 0/1 for a junk conversion" do
        rational_string = "asdfasdfasdf"

        conversion = rational_string.to_r

        expect(conversion).to be_a(Rational)
        expect(conversion).to eq(0/1)
      end
    end

    describe "String#to_s" do
      it "returns self" do
        string = "self"

        conversion = string.to_s

        expect(conversion).to eq("self")
      end
    end

    describe "String#to_sym" do
      # String#intern is an alias

      it "creates a symbol out of the given string" do
        string ="string thing"

        symbol = string.to_sym

        expect(symbol).to eq(:"string thing")
      end
    end

    describe "String#tr" do
      it "translates characters in a string from and to values provided" do
        string = "abcdefg"

        translation = string.tr("abcdefg", "its on!")

        expect(translation).to eq("its on!")
      end

      it "it compares from_str[0] with to_str[0] for conversions" do
        string = "abcdefg"
        from_str = "abcdefg".reverse
        to_str = "its on!"

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("!no sti")
      end

      # pulling from docs examples from here on out because they are actually very thorough

      it "matches on patterns" do
        string = "hello"
        from_str = "aeiou"
        to_str = "*"

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("h*ll*")
      end

      it "makes some assumptions about character assignment" do
        string = "hello"
        from_str = "aeiou"
        to_str = "AA*"

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("hAll*")
      end

      it "matches on a range of characters" do
        string = "hello"
        from_str = "a-z"
        to_str = "1-9"

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("85999")
      end

      it "actually accepts regex syntax in string form, sort of" do
        string = "hello"
        from_str = "/[hello]/"  # if this were true regex i'd expect "/(hello)/" #=> "A"
        to_str = "A"

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("AAAAA")
      end

      it "can escape ^ signs in the matchers" do
        string = "hello^world"

        translation = string.tr("\\^aeiou", "*")

        expect(translation).to eq("h*ll**w*rld")
      end

      it "can make things go away" do
        string = "\x66\nhello^world\r"
        from_str = "\x66\n\\^\r"
        to_str = ""

        translation = string.tr(from_str, to_str)

        expect(translation).to eq("helloworld")
      end

      it "tr! mutates the string in place" do
        string = "\x66\nhello^world\r"
        from_str = "\x66\n\\^\r"
        to_str = ""

        string.tr!(from_str, to_str)

        expect(string).to eq("helloworld")
      end
    end

    describe "String#tr_s" do
      it "acts like String#tr but also removes duplicated characters" do
        hello = "hello"

        tr_single = hello.tr_s("l", "r")

        expect(tr_single).to eq("hero")
      end

      it "tr_s! mutates the string in place" do
        hello = "hello"

        hello.tr_s!("l", "r")

        expect(hello).to eq("hero")
      end
    end

    xdescribe "String#unpack" do
      # unpacks encoding, come back to this when relevant
    end

    describe "String#upcase" do
      it "upcases things" do
        lowercase = "happy friday! i'm almost done this class!"

        upcased = lowercase.upcase

        expect(upcased).to eq("HAPPY FRIDAY! I'M ALMOST DONE THIS CLASS!")
      end

      it "only affects lowercase characters" do
        mixed_case = "lowercase UPPERCASE"

        upcased = mixed_case.upcase

        expect(upcased).to eq("LOWERCASE UPPERCASE")
      end

      it "upcase! mutates the string in place" do
        mixed_case = "lowercase UPPERCASE"

        mixed_case.upcase!

        expect(mixed_case).to eq("LOWERCASE UPPERCASE")
      end
    end

    describe "String#upto" do
      it "makes a series of things, works best with .to_a" do
        up_to = "a".upto("g")

        arrayify = up_to.to_a

        expect(arrayify).to eq(["a", "b", "c", "d", "e", "f", "g"])
      end

      it "returns an Enumerator if you don't call .to_a" do
        up_to = "a".upto("g")

        expect(up_to).to be_a(Enumerator)
      end

      it "returns an empty array if there's nothing to 'upto' to" do
        up_to = "a".upto("g")

        expect(up_to).to be_a(Enumerator)
      end
    end

    describe "String#valid_encoding?" do
      it "checks to see an encoding on a string is correct" do
        string = "hello".force_encoding("UTF-8")
        expect(string.valid_encoding?).to be true
      end

      it "returns false if it isn't correct" do
        string = "\x80".force_encoding("UTF-8")
        expect(string.valid_encoding?).to be false
      end
    end
  end
end
