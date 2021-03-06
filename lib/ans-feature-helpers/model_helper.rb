# vi: set fileencoding=utf-8

module Ans::Feature::Helpers::ModelHelper
  def find(model,keys,hash)
    keys, values = finder_keys keys,hash
    modelize(model).send(:"find_by_#{keys.join("_and_")}", *values)
  end
  def find!(model,keys,hash)
    keys, values = finder_keys keys,hash
    modelize(model).send(:"find_by_#{keys.join("_and_")}!", *values)
  end
  def finder_keys(keys,hash)
    [[],[]].tap{|k,v|
      keys.split(/,/).each do |name|
        name, value = column_pair name,hash[name]
        k << name
        v << value
      end
    }
  end

  def column_pair(name,value)
    case name
    when /\./
      models = name.split(".")
      name = models.pop
      names, values = [[],[]].tap{|names,values|
        name.split(",").zip(value.split(",")).each do |name,value|
          name, value = convert_name_value name,value
          names << name
          values << value
        end
      }

      model = models.pop
      value = modelize(model).send(:"find_by_#{names.join("_and_")}!", *values).id

      name = "#{model}_id"
      until models.blank?
        model = models.pop
        value = modelize(model).send(:"find_by_#{name}!", value).id
        name = "#{model}_id"
      end

    else
      name, value = convert_name_value name,value
    end

    [name, value]
  end

  def convert_name_value(name,value)
    case name
    when /_H$/
      name = name.gsub /_H$/, "_datetime"
      value = Time.parse(value)
    end

    [name, value]
  end
  def modelize(model)
    hierarchy = model.camelize.split("::")
    model_class = hierarchy.pop

    parent = Object
    hierarchy.each do |p|
      break if p == ""
      break unless parent.const_defined? p

      parent = parent.const_get p
    end

    parent.const_get(model_class)
  end
end
