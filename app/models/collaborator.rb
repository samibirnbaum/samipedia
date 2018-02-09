class Collaborator < ApplicationRecord
  #@user_id
  #@wiki_id

  belongs_to :user
  belongs_to :wiki
end
