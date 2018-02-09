class Wiki < ApplicationRecord
    #@title
    #@body
    #@private
    #@user_id
    
    belongs_to :user
    has_many :collaborators, dependent: :destroy
    has_many :users, through: :collaborators

    validates_presence_of :title
    validates_presence_of :body

    validates_length_of :title, minimum: 3
    validates_length_of :body, minimum: 15
end
