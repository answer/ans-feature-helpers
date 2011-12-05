# vi: set fileencoding=utf-8

Given /^"([^"]*)"が空の場合は中止$/ do |path|
  pending "コンテンツが存在しないため中止: #{path}" if File.read(File.join(Rails.root, path)).blank?
end
