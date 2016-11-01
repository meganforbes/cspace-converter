require 'spec_helper'

describe "CollectionSpace" do

  describe "Identifiers" do

    it "returns correct authority term type when no change required" do
      expect(CollectionSpace::Identifiers.authority_term_type('person')).to eq 'person'
    end

    it "returns correct authority term type when mapping is required" do
      expect(CollectionSpace::Identifiers.authority_term_type('location')).to eq 'loc'
    end

    it "can convert vocabulary display values to id form" do
      expect(
        CollectionSpace::Identifiers.for_option('Growing on a rock Bonsai style (Seki-joju)')
      ).to eq "growing_on_a_rock_bonsai_style_seki_joju" 
    end

    it "can convert vocabulary display values to id form with strip" do
      expect(CollectionSpace::Identifiers.for_option(' item ', true)).to eq 'item'
    end

  end

end