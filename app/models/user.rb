class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :posts, :foreign_key => "users_id", :class_name => "Post", dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2]

   def self.from_omniauth(access_token)
     data = access_token.info
     user = User.where(email: data['email']).first

     unless user
         user = User.create(
            email: data['email'],
            password: Devise.friendly_token[0,20]
         )
     end
     user
   end
end
