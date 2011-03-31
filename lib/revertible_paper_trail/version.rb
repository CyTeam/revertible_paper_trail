module RevertiblePaperTrail
  module Version
    extend ActiveSupport::Concern
    
    included do
    end

    module InstanceMethods
      def revert
        case event
          when "create"
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
