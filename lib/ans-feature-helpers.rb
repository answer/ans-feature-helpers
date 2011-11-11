require "ans-feature-helpers/version"

module Ans
  module Feature
    module Helpers
      autoload :PathHelper, "ans-feature-helpers/path_helper"

      autoload :ActionHelper, "ans-feature-helpers/action_helper"
      autoload :HelperHelper, "ans-feature-helpers/helper_helper"

      autoload :SignInHelper, "ans-feature-helpers/sign_in_helper"
    end
  end
end
