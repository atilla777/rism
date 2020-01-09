class AddRegisterToIndicatorFormatType < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          ALTER TYPE indicator_content_format
          ADD VALUE 'registry'
          AFTER 'email_author';
        SQL
      end

      change.down do
        execute <<-SQL
          DELETE FROM pg_enum
          WHERE enumlabel = 'registry'
          AND enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'indicator_content_format'
          )
        SQL
      end
    end
  end
end
