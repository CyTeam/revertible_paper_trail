require 'revertible_paper_trail'
require 'rails'
require 'paper_trail/version'

module RevertiblePaperTrail
  class Railtie < Rails::Engine
    initializer :after_initialize do
      ::Version.send :include, RevertiblePaperTrail::Version
    end
  end
end
