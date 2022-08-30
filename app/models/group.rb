class Group < ApplicationRecord
  validates :name, presence: true
  validates_uniqueness_of :name


  belongs_to :user

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :posts, dependent: :destroy
end
