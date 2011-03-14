require 'spec_helper'

describe RevertiblePaperTrail do
  it "should be valid" do
    RevertiblePaperTrail.should be_a(Module)
  end
end