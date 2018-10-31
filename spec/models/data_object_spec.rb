require 'rails_helper'

RSpec.describe DataObject do

  describe "initialization" do
    let(:data_object_no_type_or_profile) { DataObject.new }
    let(:data_object_bad_type_and_profile) { DataObject.new converter_module: "x", converter_profile: "y", import_type: 'Authority' }
    let(:data_object_ok) { DataObject.new converter_module: "Vanilla", converter_profile: "acquisition", import_type: 'Procedure' }

    it "requires a converter type" do
      expect(data_object_no_type_or_profile).to be_invalid
      expect(data_object_ok).to be_valid
    end

    it "requires a converter profile" do
      expect(data_object_no_type_or_profile).to be_invalid
      expect(data_object_ok).to be_valid
    end

    it "requires the converter type and profile to exist" do
      expect(data_object_bad_type_and_profile).to be_invalid
      expect(data_object_ok).to be_valid
    end

  end

end
