# vi: set fileencoding=utf-8

Given /^"([^"]*)"をクリアする$/ do |model|
  Object.const_get(model).delete_all
end
Given /^以下の"([^"]*)"が存在する:$/ do |model,table|
  convert_name_value = lambda{|name,value|
    case name
    when /_H$/
      name = name.gsub /_H$/, "_datetime"
      value = Time.parse(value)
    end

    [name, value]
  }

  Object.const_get(model).create!([].tap{|hashes|
    table.hashes.each do |hash|
      hashes << {}.tap{|row|
        hash.each do |name,value|
          case name
          when /\./
            models = name.split(".")
            name = models.pop
            names, values = [[],[]].tap{|names,values|
              name.split(",").zip(value.split(",")).each do |name,value|
                name, value = convert_name_value.call name, value
                names << name
                values << value
              end
            }

            model = models.pop
            value = Object.const_get(model.camelize).send :"find_by_#{names.join("_and_")}!", *values

            name = "#{model}_id"
            until models.blank?
              model = models.pop
              value = Object.const_get(model.camelize).send :"find_by_#{name}!", value
              name = "#{model}_id"
            end

            row[name] = value
          else
            name, value = convert_name_value.call name, value
            row[name] = value
          end
        end
      }
    end
  })
end
