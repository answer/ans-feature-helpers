require "ans-feature-helpers/version"

module Ans
  module Feature
    module Helpers
      autoload :PathHelper, "ans-feature-helpers/path_helper"
      autoload :ModelHelper, "ans-feature-helpers/model_helper"

      autoload :ActionHelper, "ans-feature-helpers/action_helper"
      autoload :HelperHelper, "ans-feature-helpers/helper_helper"

      autoload :BasicControllerSpecHelper, "ans-feature-helpers/basic_controller_spec_helper"
    end
  end
end
