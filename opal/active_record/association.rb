module ActiveRecord
  class Association
    attr_reader :foreign_key, :association_type, :name, :source_klass, :options

    def initialize(source_klass, association_type, name, options, connection)
      @association_type = association_type
      @name = name
      @options = options
      @connection = connection
      @source_klass = source_klass
      if @association_type == :belongs_to
        @foreign_key =  "#{name}_id"
      elsif @association_type == :has_many
        @foreign_key = "#{source_klass.table_name.singularize}_id"
      end
    end

    def table_name
      (@association_type == :belongs_to) ? @name.to_s.pluralize : @name.to_s
    end

    def klass
      Object.const_get(table_name.singularize.camelize)
    end

    def all
      where(1 => 1)
    end
    alias load all

    def where(query={})
      Relation.new(query, @connection) 
    end

    def to_s
      "#Association: #{@source_klass} #{@association_type}: #{@name}"
    end

    def hash
      name.to_s.hash
    end
  end
end
