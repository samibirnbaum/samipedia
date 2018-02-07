class RegistrationsController < Devise::RegistrationsController
    protected
  
    def after_inactive_sign_up_path_for(resource)
        if params[:commit] == "Sign up for Premium Account"
            redirect = new_charge_path
            return redirect if redirect.present?
        else
            redirect = root_path
            return redirect if redirect.present?
        end
    end

    def after_sign_up_path_for(resource)
        if params[:commit] == "Sign up for Premium Account"
            redirect = new_charge_path
            return redirect if redirect.present?
        else
            redirect = root_path
            return redirect if redirect.present?
        end
    end
  end