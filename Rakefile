class Ans::Feature::Helpers::Task
  include Ans::Releaser::GemTask

  module ClassMethods
    def install_tasks
      new.build_release_tasks
    end
  end
  extend ClassMethods

  def gem_host
    "gem.ans-web.co.jp"
  end
  def gem_root
    "/var/www/gem/public"
  end
end
