class PostsController < ApplicationController
  before_action :set_post, except: [ :index, :create ]
  before_action :set_group, only: [ :destroy, :show, :create ]


  def show 
    @post = Post.includes(:comments).find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

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

  def destroy
    @post.destroy
    redirect_to group_posts_path(@group), notice: "Post was successfully destroyed."
  end


  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end
end
