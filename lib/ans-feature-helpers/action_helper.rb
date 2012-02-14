# vi: set fileencoding=utf-8

module Ans::Feature::Helpers::ActionHelper
  def action_は(&block)
    if block
      @action = block
    else
      @action.call
    end
  end

  alias_method :the_action, :"action_は"
end
