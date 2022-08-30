class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = case params[:search]
              when 'owned'
                current_user.owned_groups
              when 'member'
                current_user.groups
              else
                Group.all
              end
    @groups = @groups.includes(:users, :posts)
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts
    @users = @group.users
    @post = Post.new
  end

  def create
    @group = Group.new(group_params.merge(user: current_user))
    if @group.save
      render turbo_stream: turbo_stream.append(
        'groups',
        partial: 'group',
        locals: {
          group: @group
        }
      )
    else
      render turbo_stream: turbo_stream.replace(
       'group_form',
        partial: 'form',
        locals: {
          group: @group
        }
    ), status: :unprocessable_entity
    end
  end

  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
  end

  def remove
    @group = Group.find(params[:group_id])
    user_group = @group.user_groups.find_by(user_id: params[:user_id])
    user_group&.destroy
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
