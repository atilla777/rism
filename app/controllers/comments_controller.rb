# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params.merge!(user_id: current_user.id))
    authorize comment
    comment.save
    @record = comment.commentable
  end

  def update
    comment = Comment.find(params[:id])
    authorize comment
    comment.update(comment_params)
    @record = comment.commentable
    render 'create'
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize comment
    @record = comment.commentable
    comment.destroy
    render 'create'
  end
  
  private
  
  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :parent_id, :content)
  end
end
