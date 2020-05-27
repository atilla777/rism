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
    clone_invetigation
    clone_indicators
    clone_enrichemnts
  end

  private

  def cloned_investigation
    new_record = @cloned_investigation.dup
    new_record.organization_id = @organization_id
    new_record.user_id = @current_user.id
    new_record.save
  end

  def clone_indicators

  end

  def clone_enrichemnts

  end
end
