require 'spec_helper'

describe RevertiblePaperTrail do
  it "should be a module" do
    RevertiblePaperTrail.should be_a(Module)
  end
  
  it "should add a revert instance method to Version" do
    Version.new.should respond_to(:revert)
  end

  context ".revert" do
    it "should revert create" do
      data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
      
      latest_version = data.versions.last
      latest_version.revert
      
      DummyData.exists?(data.id).should be_false
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

  context ".active_item" do
    it "should return current item if it exists" do
      data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
      
      latest_version = data.versions.last

      latest_version.active_item.should == data
    end

    it "should return latest destroyed version if no current item exists" do
      data = create(:dummy_data, :trailed_field => 'orig', :untrailed_field => 'orig')
      
      # Do an update
      data.trailed_field = 'new'
      data.save
      # remember this version
      first_version = data.versions.last

      # Destroy
      data.destroy
      # remember this version
      latest_version = data.versions.last

      # 
      first_version.active_item.trailed_field.should == 'new'
      latest_version.active_item.trailed_field.should == 'new'
    end
  end
end
