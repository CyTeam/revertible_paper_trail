module RevertiblePaperTrail
  module Version
    extend ActiveSupport::Concern
    
    included do
    end

    module InstanceMethods
      def revert
        case event
          when "create"
            # Do nothing if item already destroyed again
            return unless self.item
            
            self.item.destroy
          when "update"
            self.reify.save
          when "destroy"
            self.reify.save
        end
      end

      def active_item
        # Fast track if item currently exists
        active_item = item
        return active_item if active_item

        # Take latest and reify
        latest_version = self.class.subsequent(self).last || self

        return latest_version.reify
      end
    end

    module ClassMethods
    end
  end
end
