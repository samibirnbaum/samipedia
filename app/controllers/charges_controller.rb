class ChargesController < ApplicationController
    before_action :authenticate_user!
    
    def new
        @stripe_btn_data = {
            key: "#{ Rails.configuration.stripe[:publishable_key] }",
            description: "Premium Membership",
            amount: Amount.default
        }
    end

    def create
        #customer object sent to stripe
        customer = Stripe::Customer.create( #saved to stripe db
        email: current_user.email,
        card: params[:stripeToken]
        )

        #charge object sent to stripe
        charge = Stripe::Charge.create( #saved to stripe db
            customer: customer.id, # Note -- this is NOT the user_id in your app
            amount: Amount.default,
            description: "Premium Membership",
            currency: 'gbp'
        )
        
        #if all goes well
        current_user.premium! #change role to premium
        flash[:notice] = "You are now active as a Premium member ---- #{current_user.role}"
        redirect_to root_path

        #else
        rescue Stripe::CardError => e
        flash[:alert] = e.message
        redirect_to new_charge_path
    end
end
