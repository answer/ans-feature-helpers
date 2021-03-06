ans-feature-helpers
===================

テストに関連するヘルパーを提供する

cucumber の feature に限らず rspec 用のヘルパーもある


PathHelper
----------

features/support/path.rb に以下を記述

	module NavigationHelpers
	  include Ans::Feature::Helpers::PathHelper
	
	  ...
	
	  when Component.regex
	    method, args = Component.path $~
	    self.send method, *args
	
	  ...
	end


以下のパスが使用可能になる

* `'member'一覧`
* `'member'新規作成`
* `'member'新規作成エラー`
* `'member(name=田中)'詳細`
* `'member(name=田中)'編集`
* `'member(name=田中)'編集エラー`
* `'member(name=田中)'の'member_log'一覧`

* `'member_log(member.name=田中)'詳細`

* `'member'一覧(sumup)`

* `'Manage::Member'一覧(sumup)`
* `'Manage::Member(not_exist)'詳細`

基本的に、 `'controller'の{action}` というようにパスを指定する

最終的に、 `"#{controller}_path"` というようなパスに整形される

controller の後ろに、カッコで括って条件を指定できる

`has_one` の関係なら、 `(member_log.member.name=田中)` というように、チェーン表記することが出来る

複数のカラムで検索する場合、 `member_log(action_type=3000,member.name=田中)` というように指定する

`"'member'一覧(sumup)"` は、 resource member の collection :sumup なパス : `send_members_path` に整形される

日付時刻カラムは `*_H=時間` で指定することができ、「時間」部分は Time.parse で処理される

モデルの部分はモデルクラス名を指定することが出来る

条件に `not_exist` を指定すると、存在しないモデルのパスを生成する


ans-feature-helpers/step_definitions/model_steps.rb
---------------------------------------------------

`step_definitions` のどれかで require することで、以下の step が追加される


### 前提 "..."をクリアする ###

... に Member 等を指定すると、 `Member.delete_all` する


### 前提 以下の"..."が存在する: ###

... に Member 等を指定すると、 Member のデータを用意する

`has_one` の関係なら、 `member_log.member.name` というように、チェーンでカラムを指定できる

日付時刻カラムは `*_H=時間` で指定することができ、「時間」部分は Time.parse で処理される


### 前提 以下を持つ"..."が存在する: ###

Fabricate か FactoryGirl で用意したデータを投入する


### 前提 以下のFabricate"..."が存在する: ###

Fabricate で用意したデータを投入する


### 前提 以下のFactoryGirl"..."が存在する: ###

FactoryGirl.create で用意したデータを投入する


### 前提 "..."が以下である: ###

	前提 "Member(login_id)"が以下である:
	  | login_id | name | memo |
	  | hoge | 田中角栄 | 備考 |

カッコの中に指定したカラムで `find_by_*` して、テーブルで指定したカラムを上書きする

複数のキーを指定する必要がある場合、カンマで区切る(スペースを入れてはいけない)


### ならば 以下の"..."が存在すること: ###

	ならば 以下の"Member(login_id)"が存在すること:
	  | login_id | name | memo |
	  | hoge | 田中角栄 | 備考 |

カッコの中に指定したカラムで `find_by_*` して、テーブルで指定したカラムをマッチさせる

複数のキーを指定する必要がある場合、カンマで区切る(スペースを入れてはいけない)

各値は、互いに `to_s` した形式で比較されるので、少々あれかもしれない


### ならば 以下の"..."が存在しないこと: ###

	ならば 以下の"Member(login_id)"が存在しないこと:
	  | login_id |
	  | hoge |

カッコの中に指定したカラムで `find_by_*` して、存在しないことをテストする

複数のキーを指定する必要がある場合、カンマで区切る(スペースを入れてはいけない)


ans-feature-helpers/step_definitions/pending_steps.rb
-----------------------------------------------------

`step_definitions` のどれかで require することで、以下の step が追加される


### 前提 "..."が空の場合は中止 ###

... に Rails.root からの相対パスを指定すると、指定したパスのファイルの内容が空の場合、 pending される

ファイルが存在しない場合はテスト失敗となる


ActionHelper
------------

`action_は` メソッドを定義する

指定したブロックを保存して、後で実行する

	module ...SpecHelper
	  include ::Ans::Feature::Helpers::ActionHelper
	end

	describe ... do
	  include ...SpecHelper
	
	  before do
	    action_は do
	      テストするコード
	    end
	  end
	
	  it "は、 ... する" do
	    action_は.should == "..."
	  end
	end

`the_action` メソッドは `action_は` のエイリアス


HelperHelper
------------

helper のスペックを記述するヘルパー

helper で Object のインスタンスを返す

mixin で helper にモジュールをミックスインする

ActionHelper はすでにミックスインされている

	module ...SpecHelper
	  include ::Ans::Feature::Helpers::HelperHelper
	end
	
	describe ... do
	  include ...SpecHelper
	
	  before do
	    mixin ...Helper
	    action_は do
	      helper.method
	    end
	  end
	
	  it "は、 ... する" do
	    action_は.should == "..."
	  end
	end


コントローラー用基本 shared_examples
------------------------------------

### Ans::Feature::Helpers::BasicControllerSpecHelper ###

以下のメソッドを最定義する必要がある

	module Ans::Feature::Helpers::BasicControllerSpecHelper
	  def sign_in_path
	    manage_user_session_path
	  end
	end

`sign_in_path` の定義は、適当なパスに定義しておいて、 require すること

BasicControllerSpecHelper には、 ActionHelper が include されている

`action_は` ブロックの実行で、 `sign_in_path` にリダイレクトしない場合は失敗する


### shared_examples_for "Ans::Feature::Helpers::SignIn" ###

認証が必要なアクションを、認証しないで呼び出した場合に、特定のパスにリダイレクトすること

	require "ans-feature-helpers/shared_examples/basic_controller"
	
	module ...SpecHelper
	  include Ans::Feature::Helpers::BasicControllerSpecHelper
	end
	
	describe ... do
	  include ...SpecHelper
	
	  before do
	    action_は do
	      get :action, params: { name: "value" }
	    end
	  end
	
	  it_should_behave_like "Ans::Feature::Helpers::SignIn"
	end

xhr で通信する場合は、以下を使用する

	describe ... do
	  include ...SpecHelper
	
	  before do
	    action_は do
	      xhr :get, :action, params: { name: "value" }
	    end
	  end
	
	  it_should_behave_like "Ans::Feature::Helpers::SignIn(xhr)"
	end

xhr な destroy アクションの場合は以下を使用する

	describe ... do
	  include ...SpecHelper
	
	  before do
	    action_は do
	      xhr :delete, :action, params: { name: "value" }
	    end
	  end
	
	  it_should_behave_like "Ans::Feature::Helpers::SignIn(xhr-destroy)"
	end

xhr 版は、レスポンスコードのチェックだけを行う

