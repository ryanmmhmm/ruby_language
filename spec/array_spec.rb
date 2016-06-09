RSpec.describe Array do
  context "Public Class Methods" do
    xdescribe "[]" do
    end

    xdescribe ".new" do
    end

    xdescribe ".try_convert" do
    end
  end

  context "Public Instance Methods" do
    xdescribe "&" do
    end

    xdescribe "*" do
    end

    xdescribe "+" do
    end

    xdescribe "-" do
    end

    xdescribe "<<" do
    end

    xdescribe "<=>" do
    end

    xdescribe "==" do
    end

    xdescribe "ary[index]" do
    end

    xdescribe "#any?" do
    end

    xdescribe "#assoc" do
    end

    xdescribe "#at" do
    end

    xdescribe "#bsearch" do
    end

    xdescribe "#bsearch_index" do
    end

    xdescribe "#clear" do
    end

    xdescribe "#collect" do
    end

    xdescribe "#combination" do
    end

    xdescribe "#compact" do
    end

    xdescribe "#concat" do
    end

    xdescribe "#count" do
    end

    xdescribe "#cycle" do
    end

    xdescribe "#delete" do
    end

    xdescribe "#delete_at" do
    end

    xdescribe "#delete_if" do
    end

    xdescribe "#dig" do
    end

    xdescribe "#drop" do
    end

    xdescribe "#drop_while" do
    end

    xdescribe "#each" do
    end

    xdescribe "#each_index" do
    end

    xdescribe "#empty?" do
    end

    xdescribe "#eql?" do
    end

    xdescribe "#fetch" do
    end

    xdescribe "#fill" do
    end

    xdescribe "#find_index" do
    end

    xdescribe "#first" do
    end

    xdescribe "#flatten" do
    end

    xdescribe "#frozen?" do
    end

    xdescribe "#hash" do
    end

    xdescribe "#include?" do
    end

    xdescribe "#index" do
    end

    xdescribe "#initialize_copy" do
    end

    xdescribe "#insert" do
    end

    xdescribe "#to_s" do
    end

    xdescribe "#inspect" do
    end

    xdescribe "#join" do
    end

    xdescribe "#keep_if" do
    end

    xdescribe "#last" do
    end

    xdescribe "#length" do
    end

    xdescribe "#map" do
    end

    xdescribe "#pack" do
    end

    xdescribe "#permutation" do
    end

    xdescribe "#pop" do
    end

    xdescribe "#product" do
    end

    xdescribe "#push" do
    end

    xdescribe "#rassoc" do
    end

    xdescribe "#rassoc" do
    end

    xdescribe "#reject" do
    end

    xdescribe "#repeated_combination(n)" do
    end

    xdescribe "#repeated_permutation" do
    end

    xdescribe "#replace" do
    end

    xdescribe "#reverse" do
    end

    xdescribe "#reverse_each" do
    end

    xdescribe "#rindex" do
    end

    xdescribe "#rotate" do
    end

    xdescribe "#sample" do
    end

    xdescribe "#select" do
    end

    xdescribe "#shift" do
    end

    xdescribe "#shuffle" do
    end

    xdescribe "#size" do
    end

    xdescribe "#slice" do
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

    xdescribe "#to_ary" do
    end

    xdescribe "#to_h" do
    end

    xdescribe "#to_s" do
    end

    xdescribe "#transpose" do
    end

    xdescribe "#uniq" do
    end

    xdescribe "#unshift" do
    end

    xdescribe "#values_at" do
    end

    xdescribe "#zip" do
    end

    xdescribe "['ary1'] | ['ary2'] (Set Union)" do
    end
  end

  context "other" do
    describe "%W(foo bar baz) syntactic sugar" do
      it "creates an array from values of strings" do
        string_array = %W(foo bar baz)
        expect(string_array).to eq(["foo", "bar", "baz"])
      end
    end
  end
end
