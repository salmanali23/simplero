class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    record.group.users.include?(user)
  end

  def create?
    new?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def remove_comment?
    update?
  end

  def update?
    record.user == user || record.group.user == user
  end
end
