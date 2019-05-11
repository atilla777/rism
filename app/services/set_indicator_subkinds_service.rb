class SetIndicatorSubkindsService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(indicator_id, indicator_subkind_ids)
     @indicator_id = indicator_id
     @indicator_subkind_ids = indicator_subkind_ids.select(&:present?).map(&:to_i)
     @indicator_subkind_member_ids = indicator_subkind_member_ids
  end

  def execute
    @indicator_subkind_ids.each do |indicator_subkind_id|
      next if @indicator_subkind_member_ids.include?(indicator_subkind_id)
      create_indicator_member(indicator_subkind_id)
    end
    @indicator_subkind_member_ids.each do |indicator_subkind_member_id|
      next if @indicator_subkind_ids.include?(indicator_subkind_member_id)
      IndicatorSubkindMember.destroy(indicator_subkind_member_id)
    end
  end

  private

  def indicator_subkind_member_ids
    IndicatorSubkindMember.where(indicator_id: @indicator_id)
                          .pluck(:id)
  end

  def create_indicator_member(indicator_subkind_id)
    indicator_subkind_member = IndicatorSubkindMember.new(
      indicator_subkind_id: indicator_subkind_id,
      indicator_id: @indicator_id
    )
    indicator_subkind_member.save
  end
end
