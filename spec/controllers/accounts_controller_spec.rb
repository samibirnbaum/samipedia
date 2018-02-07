require 'rails_helper'
require 'random_data'

RSpec.describe AccountsController, type: :controller do
    let(:my_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }
    let(:private_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: my_user) }

    describe 'POST #upgrade_account' do
        it 'redirects user to pay and upgrade' do
            post :upgrade_account
            expect(response).to redirect_to(new_charge_path)
        end
    end

    describe 'POST #downgrade_account' do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            @user = my_user
            @user.premium!
            @user.confirm
            sign_in @user
        end

        it 'changes the role of the user to standard' do
            post :downgrade_account
            expect(@user.role).to eq("standard")
        end

        it 'changes all of users private wikis to public' do
            post :downgrade_account
            expect(private_wiki.private).to eq(false)
        end

        it 'redirects to root page' do
            post :downgrade_account
            expect(response).to redirect_to(root_path)
        end
    end
end
