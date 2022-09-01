class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.groups.merge!(scope.where(user_id: user.id))
    end
  end

  def index?
    true
  end

  def show?
    true
  end

  def new?
    true
  end

  def create?
    record.users.include?(user) || record.user == user
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def remove_member?
    update?
  end

  def owner?
    update?
  end

  def remove?
    update?
  end

  def update?
    record.user == user
  end

  def group_member?
    user.groups.include? record
  end
end
