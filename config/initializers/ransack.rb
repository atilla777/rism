Ransack.configure do |config|
  config.add_predicate 'end_of_day_lteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.end_of_day }
end
