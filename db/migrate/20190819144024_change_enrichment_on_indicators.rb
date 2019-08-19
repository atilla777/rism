class ChangeEnrichmentOnIndicators < ActiveRecord::Migration[5.1]
  def change
    change_column :indicators, :enrichment, :jsonb, null: false, default: {}
  end
end
