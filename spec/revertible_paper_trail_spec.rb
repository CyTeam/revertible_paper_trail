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
     
      it "should revert create" do
        data_id = data.id

        @created_version.revert
        
        DummyData.exists?(data_id).should be_false
      end
      
      it "should revert update" do
        data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
        
        data.trailed_field = 'new'
        data.save!
        
        latest_version = data.versions.last
        latest_version.revert
        
        data.reload
        data.trailed_field.should == 'orig'
      end

      it "should revert destroy" do
        data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
        
        data.destroy
        
        latest_version = data.versions.last
        latest_version.revert
        
        DummyData.exists?(data.id).should be_true
      end

      it "should do nothing on revert create of an already destroyed item" do
        data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
        
        data.destroy
        
        first_version = data.versions.first
        first_version.revert

        DummyData.exists?(data.id).should be_false
      end
    end
  end
end
