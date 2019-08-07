class ChangeIndicatorFormatType < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          ALTER TYPE indicator_content_format
          ADD VALUE 'sha1'
          AFTER 'md5';
        SQL
      end

      change.down do
        execute <<-SQL
          DELETE FROM pg_enum
          WHERE enumlabel = 'sha1'
          AND enumtypid = (
            SELECT oid FROM pg_type WHERE typname = 'indicator_content_format'
          )
        SQL
      end
    end
  end
end
