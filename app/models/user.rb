class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #@email
  #@password
  #@load of devise atts
  enum role: [:standard, :premium, :admin]

  has_many :wikis



  after_initialize {self.role = :standard if self.role.nil?}
  
end
