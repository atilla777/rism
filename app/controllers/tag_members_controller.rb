class TagMembersController < ApplicationController
  def create
    @tag_member = TagMember.new(tag_member_params)
    @record = @tag_member.record
    authorize TagMember
    authorize @record
    @tag_member.save
    @collapse = false
  end

  def destroy
    @tag_member = TagMember.find(params[:id])
    @record = @tag_member.record
    authorize TagMember
    authorize @record
    @tag_member.destroy
    @collapse = false
  end

  private

  def tag_member_params
    params.permit(policy(TagMember).permitted_attributes)
  end
end
