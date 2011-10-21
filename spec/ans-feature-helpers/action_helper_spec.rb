# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers
  module ActionHelperSpecHelper
    module Action
      def action_は(&block)
        if block
          @action = block
        else
          @action.call
        end
      end

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

  describe ActionHelper, "#action_は" do
    include ActionHelperSpecHelper::Action

    before do
      @item = Object.new

      mixin ActionHelper
      action_は do
        helper.action_は{@item}
        helper.action_は
      end
    end
    it "で、指定したブロックを評価して返す" do
      action_は.should == @item
    end
  end
end
