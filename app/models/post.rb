class Post < ApplicationRecord
  belongs_to :user, :foreign_key => "users_id", :class_name => "User"
  validates :title, :presence => true
  validates :body, :presence => true
end
