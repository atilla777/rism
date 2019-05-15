class SetIndicatorContextsService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator_id, indicator_context_ids)
     @indicator_id = indicator_id
     @indicator_context_ids = indicator_context_ids.select(&:present?).map(&:to_i)
     @indicator_context_member_ids = indicator_context_member_ids
  end

  def execute
    @indicator_context_ids.each do |indicator_context_id|
      next if @indicator_context_member_ids.include?(indicator_context_id)
      create_indicator_member(indicator_context_id)
    end
    @indicator_context_member_ids.each do |indicator_context_member_id|
      next if @indicator_context_ids.include?(indicator_context_member_id)
      IndicatorContextMember.destroy(indicator_context_member_id)
    end
  end

  private

  def indicator_context_member_ids
    IndicatorContextMember.where(indicator_id: @indicator_id)
                          .pluck(:id)
  end

  def create_indicator_member(indicator_context_id)
    indicator_context_member = IndicatorContextMember.new(
      indicator_context_id: indicator_context_id,
      indicator_id: @indicator_id
    )
    indicator_context_member.save
  end
end
