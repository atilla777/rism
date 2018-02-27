class TagMembersController < ApplicationController
  def create
    #record = params[:record_type].constantize.find(params[:record_id])
    # TODO: add check allowed records to add tag or just replace
    # authorize TagMember to @record.class
    @tag_member = TagMember.new(tag_member_params)
    authorize TagMember
    @tag_member.save
    @record = @tag_member.record
    @collapse = false
  #rescue ActiveRecord::RecordInvalid
  end

  def destroy
    @tag_member = TagMember.find(params[:id])
    @record = @tag_member.record
    authorize @record
    @tag_member.destroy
    @collapse = false
  #rescue ActiveRecord::RecordInvalid
  end

  private

  def tag_member_params
    params.permit(policy(TagMember).permitted_attributes)
  end
end
