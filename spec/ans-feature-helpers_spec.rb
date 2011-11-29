# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers
  describe "autoload" do
    it "は配下のモジュールの autoload を定義する" do
      [
        PathHelper,
        ModelHelper,

        ActionHelper,
        HelperHelper,

        BasicControllerSpecHelper,
      ]
    end
  end
end
