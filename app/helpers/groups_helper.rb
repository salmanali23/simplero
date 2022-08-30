module GroupsHelper

  def group_member?(group)
    current_user.groups.include? group
  end

  def owner?(group)
    current_user == group.user
  end

end
