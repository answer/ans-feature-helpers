# vi: set fileencoding=utf-8

shared_examples_for "Ans::Feature::Helpers::SignIn" do
  context "にログインせずにアクセスした場合" do
    it "は、ログイン画面にリダイレクト" do
      action_は
      response.should redirect_to sign_in_path
    end
  end
end

shared_examples_for "Ans::Feature::Helpers::SignIn(xhr)" do
  context "にログインせずにアクセスした場合" do
    it "は、 401 レスポンスコード" do
      action_は
      response.response_code.should == 401
    end
  end
end

shared_examples_for "Ans::Feature::Helpers::SignIn(xhr-destroy)" do
  context "にログインせずにアクセスした場合" do
    it "は、 302 レスポンスコード" do
      action_は
      response.response_code.should == 302
    end
  end
end
