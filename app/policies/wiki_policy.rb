class WikiPolicy < ApplicationPolicy
    include ActiveModel::Dirty
  
    def create?
        user.admin? || user.premium? || user.standard? && record.private == false
    end

    def show?
        if user.nil?
            if record.private == false 
                return true
            end
        elsif user
            if user.admin? || user.premium? || user.standard? && record.private == false
                return true
            end
        end
        return false
    end

    def edit?
        user.admin? || user.premium? || user.standard? && record.private == false
    end

    def update?
        if user.admin?
            return true
        elsif user.standard?
            if record.private == true
                return false
            end
        elsif user.premium?
            if record.user == user
                return true
            elsif record.user != user
                if record.private_changed?
                    return false
                end
            end
        end
        return true
    end

    def destroy?
        user.admin? || user.standard? && record.user == user || user.premium? && record.user == user
    end
end
