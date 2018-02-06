require 'rails_helper'
require "random_data"

RSpec.describe ChargesController, type: :controller do

    let(:my_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }

    context 'signed in' do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = my_user
            user.confirm
            sign_in user
        end
        describe 'GET #new' do
            it 'returns http status success' do
                get :new
                expect(response).to have_http_status(:success)
            end

            it 'renders new view' do
                get :new
                expect(response).to render_template(:new)
            end
        end

        describe 'POST #create' do
            it 'changes users role to premium' do
                #not sure how to enter params for stripe payment POST
            end

            it 'redirects user to home page' do
               #not sure how to enter params for stripe payment POST 
            end
        end
    end
end
