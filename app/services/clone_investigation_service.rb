# frozen_string_literal: true

class CloneInvestigationService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(cloned_investigation, organization_id, current_user)
    @cloned_investigation = cloned_investigation
    @organization_id = organization_id
    @current_user = current_user
  end

  def execute
    clone_investigation
    clone_indicators
    @new_investigation
  end

  private

  # TODO: Wrap in transaction
  def clone_investigation
    @new_investigation = @cloned_investigation.dup
    @new_investigation.organization_id = @organization_id
    @new_investigation.current_user = @current_user
    @new_investigation.custom_codename = nil
    @new_investigation.save!
  end

  def clone_indicators
    @cloned_investigation.indicators.each do |cloned_indicator|
      new_indicator = cloned_indicator.dup
      new_indicator.investigation_id = @new_investigation.id
      new_indicator.current_user = @current_user
      new_indicator.created_at = cloned_indicator.created_at
      new_indicator.save!
      clone_enrichments(cloned_indicator, new_indicator)
    end
  end

  def clone_enrichments(cloned_indicator, new_indicator)
    cloned_indicator.enrichments.each do |cloned_enrichment|
      new_enrichment = cloned_enrichment.dup
      new_enrichment.enrichmentable_id = new_indicator.id
      new_enrichment.save!
    end
  end
end
