# frozen_string_literal: true

class AgentsController < ApplicationController
  include RecordOfOrganization

  private

  def model
    Agent
  end

  def records_includes
    %i[organization]
  end

  def record_decorator(record)
    AgentDecorator.new(record)
  end
end
