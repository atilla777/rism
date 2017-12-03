class AttachmentsController < ApplicationController
  include Organizatable

  private
  def get_model
    Attachment
  end
end
