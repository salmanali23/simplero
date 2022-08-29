class GroupsController < ApplicationController
  before_action :authenticate_user!

  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
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

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
