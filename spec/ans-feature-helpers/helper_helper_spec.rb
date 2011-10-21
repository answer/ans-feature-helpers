# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers
  module HelperHelperSpecHelper
    module Helper
      include ::Ans::Feature::Helpers::ActionHelper

      def helper
        @helper ||= Object.new
      end
      def mixin(mod)
        helper.class_eval do
          include mod
        end
      end

      module Dummy
        def dummy
          "dummy"
        end
      end
    end
  end

  describe ActionHelper, "#helper" do
    include HelperHelperSpecHelper::Helper

    before do
      mixin HelperHelper
      action_は do
        helper.mixin HelperHelperSpecHelper::Helper::Dummy
        helper.helper.dummy
      end
    end
    it "で、ミックスインしたヘルパーを返す" do
      action_は.should == "dummy"
    end
  end
end
