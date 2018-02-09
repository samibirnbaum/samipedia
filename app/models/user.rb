class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #@email
  #@password
  #@load of devise atts
  enum role: [:standard, :premium, :admin]

  has_many :wikis_created, foreign_key: "user_id", class_name: "Wiki", dependent: :destroy
  has_many :collaborators, dependent: :destroy
  has_many :wikis, through: :collaborators



  after_initialize {self.role = :standard if self.role.nil?}
  
end
