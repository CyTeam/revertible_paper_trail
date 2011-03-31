class DummyData < ActiveRecord::Base
  # Paper Trail
  has_paper_trail :ignore => [:created_at, :updated_at, :untrailed_field]
end
