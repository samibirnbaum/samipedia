class WikiPolicy < ApplicationPolicy
  
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
    
    
    
    
    class Scope < Scope #can use to define a scope of a model that user sees based on role
        def resolve
            scope
        end
    end
end
