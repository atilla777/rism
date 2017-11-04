class UsersController < ApplicationController
  include DefaultActions
  include Organizatable

  private
  def get_model
    User
  end
end
