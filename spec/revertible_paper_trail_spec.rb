require 'spec_helper'

describe RevertiblePaperTrail do
  it "should be a module" do
    RevertiblePaperTrail.should be_a(Module)
  end
  
  it "should add a revert instance method to Version" do
    Version.new.should respond_to(:revert)
  end

  context "given a dummy_data object" do
    let(:data) { build(:dummy_data) }
    
    context "when has been saved" do
      before do
        data.save
        @created_version = data.versions.last
      end
     
      it "should destroy the version" do
        data_id = data.id

        @created_version.revert
        
        DummyData.exists?(data_id).should be_false
      end
    end
  end
end
