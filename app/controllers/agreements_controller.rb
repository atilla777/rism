class AgreementsController < ApplicationController
  #include DefaultActions
  include Organizatable

  private
  def get_model
    Agreement
  end
end
