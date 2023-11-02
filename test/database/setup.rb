# frozen_string_literal: true

require_relative "create_users_migration"
require_relative "create_storage_tables_user_attachments_migration"

# Writing and reading roles are required for the "previewing on the writer DB" test
ActiveRecord::Base.connection.migration_context.migrate
CreateStorageTablesUserAttachmentsMigration.migrate(:down)
CreateUsersMigration.migrate(:down)
CreateUsersMigration.migrate(:up)
CreateStorageTablesUserAttachmentsMigration.migrate(:up)
