class PostsController < ApplicationController
  before_action :set_post, except: [ :index, :create ]
  before_action :set_group


  def show
    @post = Post.includes(:comments).find(params[:id])
    @comments = @post.comments
    @comment = Comment.new
  end

  def create
    @post = @group.posts.new(post_params.merge(user: current_user))
    authorize @group
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

  def update
    authorize @post
    @post.update(post_params)
    redirect_to group_post_path(@group, @post),  notice: "Post was successfully updated."
  end 

  def destroy
    authorize @post
    @post.destroy
    redirect_to group_path(@group), status: :see_other, notice: "Post was successfully destroyed."
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
