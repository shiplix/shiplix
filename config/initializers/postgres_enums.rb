# PostgreSQL enums support (adapted from https://coderwall.com/p/azi3ka)
# Should be fixed in Rails >= 4.2 (https://github.com/rails/rails/pull/13244)

require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord
  module ConnectionAdapters
    class PostgreSQLAdapter
      module OID
        class Enum < Type
          def type_cast(value)
            value.to_s
          end
        end
      end

      def enum_types
        @enum_types ||= begin
          result = execute %q{SELECT DISTINCT oid, typname FROM pg_type where typcategory = 'E'}, 'SCHEMA'
          result.to_a.inject({}) { |h, row| h[row['oid'].to_i] = row['typname']; h }
        end
      end

      def array_types
        @array_types ||= begin
          result = execute %q{SELECT DISTINCT t.oid, tt.typname, tt.oid suboid FROM pg_type t join pg_type tt on tt.oid = t.typelem where t.typcategory = 'A'}, 'SCHEMA'
          result.to_a.inject({}) { |h, row| h[row['oid'].to_i] = [row['typname'], row['suboid'].to_i]; h }
        end
      end

      private

      def initialize_type_map_with_enum_types_support(type_map)
        initialize_type_map_without_enum_types_support(type_map)

        # populate enum types
        enum_types.reject { |_, name| OID.registered_type?(name) }.each do |oid, name|
          type_map[oid] = OID::Enum.new
        end

        # populate array types
        array_types.reject { |_, (name, _)| OID.registered_type?(name) }.each do |oid, (name, suboid)|
          type_map[oid] = OID::Array.new(type_map[suboid]) if type_map[suboid]
        end
      end

      alias_method_chain :initialize_type_map, :enum_types_support
    end

    class PostgreSQLColumn
      private

      def simplified_type_with_enum_types(field_type)
        case field_type
        when *Base.connection.enum_types.values
          field_type.to_sym
        when *Base.connection.array_types.values.map(&:first)
          field_type.to_sym
        else
          simplified_type_without_enum_types(field_type)
        end
      end

      alias_method_chain :simplified_type, :enum_types
    end
  end
end
