class RemoveEnrichmentFromIndicators < ActiveRecord::Migration[5.1]
  def change
    remove_column :indicators, :enrichment, :jsonb
  end
end
