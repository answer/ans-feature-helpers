# vi: set fileencoding=utf-8

shared_examples_for "Ans::Feature::Helpers::SignIn" do
  context "にログインせずにアクセスした場合" do
    it "は、ログイン画面にリダイレクト" do
      action_は
      response.should redirect_to sign_in_path
    end
  end
end
