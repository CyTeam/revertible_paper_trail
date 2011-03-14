require 'spec_helper'

describe RevertiblePaperTrail do
  it "should be a module" do
    RevertiblePaperTrail.should be_a(Module)
  end
  
  it "should add a revert instance method to Version" do
    Version.new.should respond_to(:revert)
  end
end
