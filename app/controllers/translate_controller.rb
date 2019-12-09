# frozen_string_literal: true

class TranslateController < ApplicationController
  def show
    @translated = YandexTranslateBroker.call(params[:text])
      .fetch('text', '')&.first
    render 'translated'
  end
end
