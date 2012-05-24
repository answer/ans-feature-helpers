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
Given /^以下の(Fabricate|FactoryGirl)"([^"]*)"が存在する:$/ do |type,model,table|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  table.hashes.each do |hash|
    model_name = model.split("::").pop.underscore.singularize.to_sym
    fixture_row = {}.tap{|row|
      hash.each do |name,value|
        name, value = column_pair name,value
        row[name] = value
      end
    }
    case type
    when "Fabricate"
      Fabricate(model_name,fixture_row)
    when "FactoryGirl"
      FactoryGirl.create(model_name,fixture_row)
    end
  end
end
Given /^"([^"(]*)\(([^")]*)\)"が以下である:$/ do |model,keys,table|
  class << self
    include Ans::Feature::Helpers::ModelHelper
  end

  table.hashes.each do |hash|
    item = find! model,keys,hash

    hash.each do |name,value|
      if name != keys
        item[name] = value
      end
    end

    item.save!
  end
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
