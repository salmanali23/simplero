class RepliesController < ApplicationController
    before_action :set_comment
  
    def create
      @reply = @comment.replies.new(reply_params.merge(user: current_user))
      if @reply.save
        render turbo_stream: turbo_stream.append(
          "comment_replies_#{@comment.id}",
          html: ReplyComponent.new(reply: @reply, current_user: current_user).render_in(ActionController::Base.new.view_context)
        )
      else
        render turbo_stream: turbo_stream.replace(
         "reply_form_#{@comment.id}",
          partial: 'form',
          locals: {
            reply: @reply,
            comment: @comment
          }
      ), status: :unprocessable_entity
      end
    end

    private

    def reply_params
      params.require(:reply).permit(:content)
    end

    def set_comment
      @comment = Comment.find(params[:comment_id])
    end 
end
  