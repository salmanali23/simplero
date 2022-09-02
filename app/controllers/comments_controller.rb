class CommentsController < ApplicationController
    before_action :set_group, :set_post, :set_reply
  
    def create
      @comment = @post.comments.new(comment_params.merge(user: current_user))
      if @comment.save
        render turbo_stream: turbo_stream.append(
          'post_comments',
          CommentComponent.new(comment: @comment, current_user: current_user).render_in(view_context)
        )
      else
        render turbo_stream: turbo_stream.replace(
         'comment_form',
          partial: 'form',
          locals: {
            comment: @comment
          }
      ), status: :unprocessable_entity
      end
    end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end 

    def set_reply
      @reply = Reply.new
    end
end
  