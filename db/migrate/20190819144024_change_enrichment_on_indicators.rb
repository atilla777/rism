class ChangeEnrichmentOnIndicators < ActiveRecord::Migration[5.1]
  def change
    reversible do |change|
      change.up do
        change_column :indicators, :enrichment, :jsonb, null: false, default: {}
      end

      change.down do
        change_column :indicators, :enrichment, :jsonb, null: false, default: '{}'
      end
    end
  end
end
