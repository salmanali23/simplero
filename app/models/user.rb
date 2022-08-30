class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :owned_groups, class_name: 'Group', dependent: :destroy
end
