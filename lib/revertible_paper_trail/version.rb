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
    end

    module ClassMethods
    end
  end
end
