module RevertiblePaperTrail
  module Version
    extend ActiveSupport::Concern
    
    included do
    end

    module InstanceMethods
      def revert
        case event
          when "create"
            item.destroy
          when "update"
            previous.reify.save
          when "destroy"
            reify.save
        end
      end
    end

    module ClassMethods
    end
  end
end
