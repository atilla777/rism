# frozen_string_literal: true

class ImportVulnersController < ApplicationController
  def new
    authorize Vulnerability
  end

  def create
    authorize Vulnerability
    @file = params[:file]
    @format = params[:file_format]
    @errors = ImportVulnersCommand.call(@file, @format)
    render :new
  end
end
