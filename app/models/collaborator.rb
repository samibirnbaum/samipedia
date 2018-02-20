class Collaborator < ApplicationRecord
  #@user_id
  #@wiki_id

  belongs_to :user
  belongs_to :wiki

  validates :user_id, uniqueness: {scope: :wiki_id, message: "You cannot add the same user twice"} #checks that both atts of user and wiki are unique
end