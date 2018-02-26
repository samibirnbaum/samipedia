class WikiPolicy < ApplicationPolicy
    include ActiveModel::Dirty

    def new?
        !user.nil?
    end
  
    def create?
        user.admin? || user.premium? || user.standard? && record.private == false
    end

    def show?
        record.private == false || user.admin? || record.collaborators.where(user: user).any?
    end

    def edit?
        record.private == false || user.admin? || record.collaborators.where(user: user).any?
    end

    def update?
        user.admin? || record.user == user || record.private == false && !record.private_changed? || record.collaborators.where(user: user).any? && !record.private_changed?
    end

    def destroy?
        user.admin? || record.user == user
    end

    
    
    class Scope
        attr_reader :user, :scope
        
        def initialize(user, scope)
            @user = user
            @scope = scope
        end

        def resolve
            wikis = []

            if user.nil?
                all_wikis = scope.all
                all_wikis.each do |wiki|
                    if wiki.private == false
                        wikis << wiki
                    end
                end
            elsif user.admin?
                wikis = scope.all
            elsif user.premium?
                all_wikis = scope.all
                all_wikis.each do |wiki|
                    if wiki.private == false || wiki.collaborators.where(user: user).any? || wiki.user == user
                        wikis << wiki
                    end
                end
            elsif user.standard?
                all_wikis = scope.all
                all_wikis.each do |wiki|
                    if wiki.private == false || wiki.collaborators.where(user: user).any?
                        wikis << wiki
                    end
                end
            end
            wikis.sort_by{|wiki| wiki.title.downcase}
        end
    end
end
