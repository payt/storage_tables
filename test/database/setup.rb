# frozen_string_literal: true

require_relative "create_posts_migration"
require_relative "create_storage_tables_post_attachments_migration"

# Writing and reading roles are required for the "previewing on the writer DB" test
ActiveRecord::Base.connection.migration_context.migrate
CreatePostsMigration.migrate(:up)
CreateStorageTablesPostAttachmentsMigration.migrate(:up)
