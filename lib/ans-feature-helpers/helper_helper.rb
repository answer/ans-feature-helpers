# vi: set fileencoding=utf-8

module Ans::Feature::Helpers
  module HelperHelper
    include ActionHelper

    def helper
      @helper ||= Object.new
    end
    def mixin(mod)
      helper.class_eval do
        include mod
      end
    end
  end
end
