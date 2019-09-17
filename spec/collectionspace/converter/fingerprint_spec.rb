require 'spec_helper'

describe "CollectionSpace" do

  describe "Fingerprint" do
    describe "Parts" do

      it "can get authority parts" do
        expect(
          Lookup.parts_for("Authority").parts
        ).to eq [:type, :subtype, :title]
      end

      it "can get procedure parts" do
        expect(
          Lookup.parts_for("Procedure").parts
        ).to eq [:type, :identifier_field, :identifier]
      end

      it "can get relationship parts" do
        expect(
          Lookup.parts_for("Relationship").parts
        ).to eq []
      end
    end
  end

end
