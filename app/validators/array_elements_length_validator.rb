class ArrayElementsLengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    min = options.fetch(:min)
    max = options.fetch(:max)
    if value.any? { |element| element.size > max }
      add_max_error(record, attribute)
    end
    if value.any? { |element| element.size < min }
      add_min_error(record, attribute)
    end
  end

  private

  def add_max_error(record, attribute)
    #TODO: translate
    record.errors.add(attribute, 'Illegal element lenght - too big')
  end

  def add_min_error(record, attribute)
    #TODO: translate
    record.errors.add(attribute, 'Illegal element lenght - too small')
  end
end
