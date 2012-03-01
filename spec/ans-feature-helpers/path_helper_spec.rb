# vi: set fileencoding=utf-8

require 'spec_helper'

module Ans::Feature::Helpers::PathHelper
  module ComponentSpecHelper
    module Regex
      include ::Ans::Feature::Helpers::ActionHelper
    end

    module Path
      include ::Ans::Feature::Helpers::ActionHelper
    end
  end

  describe Component, "#regex のマッチ" do
    include ComponentSpecHelper::Regex

    before do
      action_は do
        Component.regex =~ "'controller'の'controller(where)'一覧(sub)"
      end
    end
    it "で、 5つのキャプチャが取得できる" do
      action_は
      $~.to_a.length.should == 6
    end
  end

  describe Component, "#path" do
    include ComponentSpecHelper::Path

    before do
      action_は do
        Component.regex =~ @path
        Component.path $~
      end

      class ::Controller; end
      class ::ControllerLog; end
      class ::ControllerDetailLog; end

      module ::Ans
        class MyController; end
      end

      @items = {
        zero: 0,

        item: Object.new,
        item2: Object.new,
        item3: Object.new,

        id: Object.new,
        id2: Object.new,
      }
      @stubs = {
        controller: proc{ stub(::Controller).find_by_name!("名前"){@items[:item]} },
        controller_datetime: proc{
          time = Object.new
          stub(Time).parse("10:00"){time}
          stub(::Controller).find_by_input_datetime!(time){@items[:item]}
        },
        controller_log: proc{ stub(::ControllerLog).find_by_name!("名前"){@items[:item2]} },

        controller_values: proc{ stub(::Controller).find_by_name_and_value!("名前","値"){@items[:item]} },
        controller_refs: proc{
          stub(::ControllerLog).find_by_name!("名前"){@items[:item2]}
          stub(@items[:item2]).id{@items[:id]}
          stub(::Controller).find_by_controller_log_id!(@items[:id]){@items[:item]}
        },
        controller_detail_refs: proc{
          stub(::ControllerDetailLog).find_by_name!("名前"){@items[:item3]}
          stub(@items[:item3]).id{@items[:id2]}
          stub(::ControllerLog).find_by_controller_detail_log_id!(@items[:id2]){@items[:item2]}
          stub(@items[:item2]).id{@items[:id]}
          stub(::Controller).find_by_controller_log_id!(@items[:id]){@items[:item]}
        },

        ans_controller_values: proc{ stub(::Ans::MyController).find_by_name_and_value!("名前","値"){@items[:item]} },
      }
    end


    [
      [ "'controller'一覧",                  [:controllers_path,    []] ],
      [ "'controller'新規作成",              [:new_controller_path, []] ],
      [ "'controller'新規作成エラー",        [:controllers_path,    []] ],

      [ "'controller(name=名前)'詳細",       [:controller_path,      [:item]], [:controller] ],
      [ "'controller(name=名前)'編集",       [:edit_controller_path, [:item]], [:controller] ],
      [ "'controller(name=名前)'編集エラー", [:controller_path,      [:item]], [:controller] ],

      [ "'controller(input_H=10:00)'詳細", [:controller_path, [:item]], [:controller_datetime] ],

      [ "'controller(name=名前)'の'controller_log'一覧",
        [:controller_controller_logs_path, [:item]], [:controller] ],

      [ "'controller(name=名前)'の'controller_log(name=名前)'の'controller_detail_log'一覧",
        [:controller_controller_log_controller_detail_logs_path, [:item, :item2]], [:controller, :controller_log] ],

      [ "'controller(name=名前,value=値)'詳細",       [:controller_path, [:item]], [:controller_values] ],
      [ "'controller(controller_log.name=名前)'詳細", [:controller_path, [:item]], [:controller_refs] ],
      [ "'controller(controller_log.controller_detail_log.name=名前)'詳細",
        [:controller_path, [:item]], [:controller_detail_refs] ],

      [ "'controller'一覧(sumup)",                  [:sumup_controllers_path,    []] ],
      [ "'controller'新規作成(sumup)",              [:new_sumup_controller_path, []] ],
      [ "'controller'新規作成エラー(sumup)",        [:sumup_controllers_path,    []] ],

      [ "'controller(name=名前)'詳細(sumup)",       [:sumup_controller_path,      [:item]], [:controller] ],
      [ "'controller(name=名前)'編集(sumup)",       [:edit_sumup_controller_path, [:item]], [:controller] ],
      [ "'controller(name=名前)'編集エラー(sumup)", [:sumup_controller_path,      [:item]], [:controller] ],

      [ "'Ans::MyController'一覧",                     [:ans_my_controllers_path, []] ],
      [ "'Ans::MyController(name=名前,value=値)'詳細", [:ans_my_controller_path, [:item]], [:ans_controller_values] ],
      [ "'Ans::MyController(not_exist)'詳細",          [:ans_my_controller_path, [:zero]] ],
    ].each do |path,expect,stub_procs|
      describe "#{path}" do
        it "で、 #{expect[0]} を返す" do
          stub_procs.each{|name| @stubs[name].call} if stub_procs
          @path = path
          expect[1] = expect[1].map{|name| @items[name]}
          action_は.should == expect
        end
      end
    end
  end
end
