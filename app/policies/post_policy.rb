class PostPolicy < ApplicationPolicy
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
    user == record.user || user == record.group.user
  end
end
