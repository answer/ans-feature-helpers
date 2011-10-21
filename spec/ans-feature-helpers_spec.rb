# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers
  describe PathHelper do
    it "はロードできる" do
      PathHelper.should == PathHelper
    end
  end

  describe ActionHelper do
    it "はロードできる" do
      ActionHelper.should == ActionHelper
    end
  end
  describe HelperHelper do
    it "はロードできる" do
      HelperHelper.should == HelperHelper
    end
  end
end
