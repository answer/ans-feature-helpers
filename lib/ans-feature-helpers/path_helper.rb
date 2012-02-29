# vi: set fileencoding=utf-8

module Ans::Feature::Helpers::PathHelper
  module Component
    class << self
      include Ans::Feature::Helpers::ModelHelper

      def regex
        /^((?:'(?:[^'(]+)(?:\((?:[^']+)\))?'の)*)'([^'(]+)(?:\(([^']+)\))?'(一覧|新規作成(?:エラー)?|詳細|編集(?:エラー)?)(?:\((.+)\))?$/
      end
      def path(match)
        match, tips, model, condition, page, sub = *match

        path_components = []
        values = []

        prefix_match(tips).each do |model,condition|
          path_component, value = find_by_conditions(model, condition)
          path_components << path_component
          values << value
        end

        path_components << sub if sub

        case page
        when /^一覧|新規作成エラー$/
          path_components << model.pluralize
        when /^新規作成$/
          path_components.unshift "new"
          path_components << model
        when /^詳細|編集(?:エラー)?$/
          path_components.unshift "edit" if page == "編集"
          path_component, value = find_by_conditions(model, condition)
          path_components << path_component
          values << value
        end

        path_components << "path"
        [path_components.map{|p| p.split("::").map{|tip| tip.underscore}.join("_")}.join("_").to_sym, values]
      end

      private

      def find_by_conditions(model,condition)
        conditions, values = [[],[]].tap{|conditions,values|
          condition_match(condition).each do |column,value|
            models = column.split(".")
            column = models.pop
            unless models.blank?
              column, value = find_by_models models, column, value
            end

            conditions << column
            values << value
          end
        }
        [model, modelize(model.camelize).send("find_by_#{conditions.join("_and_")}!", *values)]
      end
      def find_by_models(models,column,value)
        model = models.pop
        value = modelize(model.camelize).send("find_by_#{column.split(",").join("_and_")}!", *value.split(",")).id
        column = "#{model}_id"
        until models.blank?
          model = models.pop
          value = modelize(model.camelize).send("find_by_#{column}!", value).id
          column = "#{model}_id"
        end
        [column, value]
      end
      def prefix_match(tips)
        [].tap{|result|
          until tips.blank?
            tips =~ /^'([^'(]+)(?:\(([^)']+)\))?'の/
            result << [$1,$2]
            tips = $'
          end
        }
      end
      def condition_match(condition)
        [].tap{|result|
          until condition.blank?
            condition =~ /^([^=]+)=([^,]+),?/
            name, value, condition = $1, $2, $'

            case name
            when /_H$/
              name.gsub! /_H$/, "_datetime"
              value = Time.parse(value)
            end

            result << [name,value]
          end
        }
      end
    end
  end
end
