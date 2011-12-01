# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers
  module ModelHelperSpecHelper
    module Methods
      include HelperHelper
    end
  end

  describe ModelHelper do
    include ModelHelperSpecHelper::Methods

    before do
      mixin ModelHelper
    end

    describe "#find" do
      before do
        class ::AnsFeatureHelpersModelHelperSpecHelperFind; end

        @model = "ans_feature_helpers_model_helper_spec_helper_find"
        @keys = "key1,key2,key3"
        @hash = {
          "key1" => "value1",
          "key2" => "value2",
          "key3" => "value3",
          "key4" => "value4",
          "key5" => "value5",
        }
        @value_fazzy = Object.new
        @value_strict = Object.new

        stub(AnsFeatureHelpersModelHelperSpecHelperFind).find_by_key1_and_key2_and_key3("value1", "value2", "value3"){@value_fazzy}
        stub(AnsFeatureHelpersModelHelperSpecHelperFind).find_by_key1_and_key2_and_key3!("value1", "value2", "value3"){@value_strict}
      end

      context "!なしメソッド" do
        before do
          action_は do
            helper.find @model,@keys,@hash
          end
        end
        it "は、指定したキーの値を取得する" do
          action_は.should == @value_fazzy
        end
      end

      context "!ありメソッド" do
        before do
          action_は do
            helper.find! @model,@keys,@hash
          end
        end
        it "は、指定したキーの値を取得する" do
          action_は.should == @value_strict
        end
      end
    end

    describe "#finder_keys" do
      before do
        @keys = "key1,key2,key3"
        @hash = {
          "key1" => "value1",
          "key2" => "value2",
          "key3" => "value3",
          "key4" => "value4",
          "key5" => "value5",
        }

        action_は do
          helper.finder_keys @keys,@hash
        end
      end

      it "は、キーを抽出するための配列を返す" do
        action_は.should == [["key1","key2","key3"],["value1","value2","value3"]]
      end
    end

    describe "#column_pair" do
      before do
        action_は do
          helper.column_pair @name,@value
        end
      end

      context "チェーンではない場合" do
        before do
          @name, @value = "name", "value"
        end
        it "は、名前と値をそのまま返す" do
          action_は.should == [@name, @value]
        end
      end

      context "チェーンで記述されている場合" do
        before do
          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair1; end
          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair2; end
          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair3; end

          @name = "ans_feature_helpers_model_helper_spec_helper_column_pair1.ans_feature_helpers_model_helper_spec_helper_column_pair2.ans_feature_helpers_model_helper_spec_helper_column_pair3.name"
          @value = "value"

          @model1 = Object.new
          @model2 = Object.new
          @model3 = Object.new

          @id1 = Object.new
          @id2 = Object.new
          @id3 = Object.new

          stub(AnsFeatureHelpersModelHelperSpecHelperColumnPair3).find_by_name!(@value){@model3}
          stub(@model3).id{@id3}
          stub(AnsFeatureHelpersModelHelperSpecHelperColumnPair2).find_by_ans_feature_helpers_model_helper_spec_helper_column_pair3_id!(@id3){@model2}
          stub(@model2).id{@id2}
          stub(AnsFeatureHelpersModelHelperSpecHelperColumnPair1).find_by_ans_feature_helpers_model_helper_spec_helper_column_pair2_id!(@id2){@model1}
          stub(@model1).id{@id1}
        end
        it "は、モデルのチェーンを解決する" do
          action_は.should == ["ans_feature_helpers_model_helper_spec_helper_column_pair1_id", @id1]
        end
      end
    end

    describe "#convert_name_value" do
      before do
        now = Time.parse("2011/01/01 10:00:00")
        stub(Time).now{now}

        action_は do
          helper.convert_name_value @name, @value
        end
      end
      it "は、 datetime を変換して返す" do
        @name = "from_H"
        @value = "10:00"
        action_は.should == ["from_datetime", Time.parse(@value)]
      end
    end

    describe "#modelize" do
      before do
        class ::AnsFeatureHelpersModelHelperSpecHelperModelize; end
        action_は do
          helper.modelize "ans_feature_helpers_model_helper_spec_helper_modelize"
        end
      end
      it "は、 camelize したクラスを取得する" do
        action_は.should == AnsFeatureHelpersModelHelperSpecHelperModelize
      end
    end
  end
end
