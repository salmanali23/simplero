class CommentsController < ApplicationController
    before_action :find_group, :find_post
  
    def create
      @comment = @post.comments.new(comment_params.merge(user: current_user))
      if @comment.save
        render turbo_stream: turbo_stream.append(
          'comments',
          partial: 'comment',
          locals: {
            comment: @comment
          }
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

    def find_post
      @post = Post.find(params[:post_id])
    end

    def find_group
      @group = Group.find(params[:group_id])
    end 
end
  