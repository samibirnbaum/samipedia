class CollaboratorPolicy < ApplicationPolicy
    include ActiveModel::Dirty

    def create?
        user.premium? && record.wiki.user == user || user.admin?
    end

    def destroy?
        user.premium? && record.wiki.user == user || user.admin?
    end
end