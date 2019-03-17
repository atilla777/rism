class CreateIndicatorsService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(text, investigation_id, user_id)
     @text = text
     @investigation_id = investigation_id
     @user_id = user_id
  end

  def execute
    @text.split("\n")
        .map do |string|
          next if string.blank?
          create_indicator(string)
        end
  end

  private

  def create_indicator(string)
    string.strip!
     indicator_params = Indicator.cast_indicator(string)
     return unless indicator_params.fetch(:ioc_kind, false)
     indicator_params.merge!(
       investigation_id: @investigation_id,
       user_id: @user_id,
       trust_level: :unknown,
       enrichment: {}
     )
     indicator = Indicator.new(indicator_params)
     indicator.current_user = User.find(@user_id)
     indicator.save
  end
end
