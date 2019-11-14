require 'arel/nodes/binary'
require 'arel/predications'
require 'arel/visitors/postgresql'

module Arel
  class Nodes::ContainsArray < Arel::Nodes::Binary
    def operator
      :"@>"
    end
  end

  class Nodes::OverlapArray < Arel::Nodes::Binary
    def operator
      :"&&"
    end
  end

  class Visitors::PostgreSQL
    private

    def visit_Arel_Nodes_ContainsArray(o, collector)
      infix_value o, collector, ' @> '
    end

    def visit_Arel_Nodes_OverlapArray(o, collector)
      infix_value o, collector, ' && '
    end
  end

  module Predications
    def arr_contains(other)
      Nodes::ContainsArray.new self, Nodes.build_quoted(other, self)
    end

    def arr_overlap(other)
      Nodes::OverlapArray.new self, Nodes.build_quoted(other, self)
    end
  end
end

Ransack.configure do |config|
  config.sanitize_custom_scope_booleans = false

  config.add_predicate :contains_array, arel_predicate: :contains

  config.add_predicate(
    'end_of_day_lteq',
    arel_predicate: 'lteq',
    formatter: proc { |v| v.end_of_day }
  )

  # last N days filter
  config.add_predicate(
    'last_days',
    arel_predicate: 'gteq',
    formatter: proc { |v| v.to_i.days.ago },
    type: :integer,
    compounds: false
  )

  # last N weeks filter
  config.add_predicate(
    'last_weeks',
    arel_predicate: 'gteq',
    formatter: proc { |v| v.to_i.weeks.ago },
    type: :integer,
    compounds: false
  )

  # last N months filter
  config.add_predicate(
    'last_months',
    arel_predicate: 'gteq',
    formatter: proc { |v| v.to_i.months.ago },
    type: :integer,
    compounds: false
  )

  # last N years filter
  config.add_predicate(
    'last_years',
    arel_predicate: 'gteq',
    formatter: proc { |v| v.to_i.years.ago },
    type: :integer,
    compounds: false
  )

  config.add_predicate(
    :arr_cont,
    arel_predicate: :contained_within_or_equals,
    wants_array: true
  )

  arr_formter = Proc.new do |values|
    string = values.split(',')
                   .map(&:strip)
                   .join(',')
    "{#{string}}"
  end

  config.add_predicate 'arr_cont',
    arel_predicate: 'arr_contains',
    formatter: arr_formter,
    validator: proc { |v| v.present? },
    type: :string

  config.add_predicate 'arr_over',
    arel_predicate: 'arr_overlap',
    formatter: arr_formter,
    validator: proc { |v| v.present? },
    type: :string
end
