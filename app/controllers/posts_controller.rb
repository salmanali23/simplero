class PostsController < ApplicationController

  def create
    @post = @group.posts.new(post_params.merge(user: current_user))
    if @post.save
      render turbo_stream: turbo_stream.append(
        'posts',
        partial: 'post',
        locals: {
          post: @post
        }
      )
    else
      render turbo_stream: turbo_stream.replace(
       'post_form',
        partial: 'form',
        locals: {
          post: @post
        }
    ), status: :unprocessable_entity
    end
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
