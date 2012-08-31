module RevertiblePaperTrail
  module Version
    extend ActiveSupport::Concern
    
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

    def current_item
      return nil if event == 'destroy'

      if self.next
        self.next.reify
      else
        # Use active item as it should exist
        self.item
      end
    end

    def previous_item
      case event
        when "create"
          nil
        when "update"
          current_item.previous_version
        when "destroy"
          reify
      end
    end

    def versions
      active_item.versions
    end
  end
end
