class AccountsController < ApplicationController

    def upgrade_account
        redirect_to(new_charge_path)
    end

    def downgrade_account
        current_user.standard!
        
        if current_user.wikis.where(private: true).any?
            current_user.wikis.where(private: true).each { |wiki| wiki.update_attribute(:private, false) }
        end

        flash[:notice] = "Your account has been downgarded. You no longer have access to Private Wikis"
        redirect_to(root_path)
    end
end
