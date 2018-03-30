class VersionPolicy < ApplicationPolicy
  #include RecordPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def revert?
    return true if @user.admin_editor_reader?
    @user.can? :edit, 'Versions'
  end
end
