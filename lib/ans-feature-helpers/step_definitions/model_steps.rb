# vi: set fileencoding=utf-8

Given /^"([^"]*)"をクリアする$/ do |model|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  modelize(model).delete_all
end
Given /^以下の"([^"]*)"が存在する:$/ do |model,table|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  modelize(model).create!([].tap{|hashes|
    table.hashes.each do |hash|
      hashes << {}.tap{|row|
        hash.each do |name,value|
          name, value = column_pair name,value
          row[name] = value
        end
      }
    end
  })
end
Then /^以下の"([^"(]*)\(([^")]*)\)"が存在すること:$/ do |model,keys,table|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  table.hashes.each do |hash|
    item = find! model,keys,hash

    hash.each do |name,value|
      name, value = column_pair name,value
      item[name].to_s.should == value.to_s
    end
  end
end
Then /^以下の"([^"(]*)\(([^")]*)\)"が存在しないこと:$/ do |model,keys,table|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  table.hashes.each do |hash|
    find(model,keys,hash).should == nil
  end
end
