require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module ConfigurableEnum
  module Generators
    class SetupGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      desc 'Generates migrations for mapping data'

      source_root File.expand_path('../templates', __FILE__)

      def setup_migrations
        migration_template 'migrations/mapping.erb', "db/migrate/#{name_u}.rb"
      end

      def setup_models
        template 'models/mapping.erb', "app/models/#{name_u}.rb"
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def name_u; name.underscore + '_mapping' end
      def name_c; name_u.camelize end
      def name_up; name_u.pluralize end
    end
  end
end
