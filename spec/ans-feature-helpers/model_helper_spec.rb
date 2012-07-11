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
        class ::AnsFeatureHelpersModelHelperSpecHelperFind
          class << self
            def find_by_key1_and_key2_and_key3(*args)
              "fazzy: #{args.join(",")}"
            end
            def find_by_key1_and_key2_and_key3!(*args)
              "strict: #{args.join(",")}"
            end
          end
        end

        @model = "ans_feature_helpers_model_helper_spec_helper_find"
        @keys = "key1,key2,key3"
        @hash = {
          "key1" => "value1",
          "key2" => "value2",
          "key3" => "value3",
          "key4" => "value4",
          "key5" => "value5",
        }
      end

      context "!なしメソッド" do
        before do
          action_は do
            helper.find @model,@keys,@hash
          end
        end
        it "は、指定したキーの値を取得する" do
          action_は.should == "fazzy: value1,value2,value3"
        end
      end

      context "!ありメソッド" do
        before do
          action_は do
            helper.find! @model,@keys,@hash
          end
        end
        it "は、指定したキーの値を取得する" do
          action_は.should == "strict: value1,value2,value3"
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
          @name = "ans_feature_helpers_model_helper_spec_helper_column_pair1.ans_feature_helpers_model_helper_spec_helper_column_pair2.ans_feature_helpers_model_helper_spec_helper_column_pair3.name"
          @value = "value"

          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair_Model
            def id=(id)
              @id = id
            end
            def id
              @id
            end
          end

          @model1 = ::AnsFeatureHelpersModelHelperSpecHelperColumnPair_Model.new
          @model2 = ::AnsFeatureHelpersModelHelperSpecHelperColumnPair_Model.new
          @model3 = ::AnsFeatureHelpersModelHelperSpecHelperColumnPair_Model.new

          @id1 = Object.new
          @id2 = Object.new
          @id3 = Object.new

          @model1.id = @id1
          @model2.id = @id2
          @model3.id = @id3

          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair1
            class << self
              def model=(model)
                @model = model
              end
              def find_by_ans_feature_helpers_model_helper_spec_helper_column_pair2_id!(value)
                @model
              end
            end
          end
          ::AnsFeatureHelpersModelHelperSpecHelperColumnPair1.model = @model1

          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair2
            class << self
              def model=(model)
                @model = model
              end
              def find_by_ans_feature_helpers_model_helper_spec_helper_column_pair3_id!(value)
                @model
              end
            end
          end
          ::AnsFeatureHelpersModelHelperSpecHelperColumnPair2.model = @model2

          class ::AnsFeatureHelpersModelHelperSpecHelperColumnPair3
            class << self
              def model=(model)
                @model = model
              end
              def find_by_name!(value)
                @model
              end
            end
          end
          ::AnsFeatureHelpersModelHelperSpecHelperColumnPair3.model = @model3
        end
        it "は、モデルのチェーンを解決する" do
          action_は.should == ["ans_feature_helpers_model_helper_spec_helper_column_pair1_id", @id1]
        end
      end
    end

    describe "#convert_name_value" do
      before do
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

      context "モジュールを含まない場合" do
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

      context "モジュールを含む場合" do
        before do
          module ::Ans
            class FeatureHelpersModelHelperSpecHelperModelize; end
          end
          action_は do
            helper.modelize "Ans::FeatureHelpersModelHelperSpecHelperModelize"
          end
        end
        it "は、適切なクラスを取得する" do
          action_は.should == ::Ans::FeatureHelpersModelHelperSpecHelperModelize
        end
      end

      context "モジュールを含むが、モジュールの下ではなく、トップに定義されている場合" do
        before do
          class ::AnsFeatureHelpersModelHelperSpecHelperModelize; end
          action_は do
            helper.modelize "Ans::AnsFeatureHelpersModelHelperSpecHelperModelize"
          end
        end
        it "は、適切なクラスを取得する" do
          action_は.should == ::AnsFeatureHelpersModelHelperSpecHelperModelize
        end
      end

      context "モジュールを含むが、モジュールの下ではなく、上位に定義されている場合" do
        before do
          module ::Ans
            class FeatureHelpersModelHelperSpecHelperModelize; end
          end
          action_は do
            helper.modelize "Ans::Sub::FeatureHelpersModelHelperSpecHelperModelize"
          end
        end
        it "は、適切なクラスを取得する" do
          action_は.should == ::Ans::FeatureHelpersModelHelperSpecHelperModelize
        end
      end

    end
  end
end
