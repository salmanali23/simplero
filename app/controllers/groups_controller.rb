class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:edit, :show, :update]

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
    @posts = @group.posts
    @users = @group.users
    @post = Post.new
  end

  def edit; end

  def update
    @group.update(group_params)
    redirect_to group_path(@group), status: :see_other
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
    render turbo_stream: turbo_stream.replace("join_member_#{@group.id}", '')
  end

  def remove
    @group = Group.find(params[:group_id])
    authorize @group
    user_group = @group.user_groups.find_by(user_id: params[:user_id])
    user_group&.destroy
    render turbo_stream: turbo_stream.replace("remove_member_#{params[:user_id]}", '')
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
