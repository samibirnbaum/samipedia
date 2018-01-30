require 'rails_helper'
require "random_data"

RSpec.describe WikisController, type: :controller do
    let(:my_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }
    let(:wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }
    
    describe 'GET #index' do
        it 'assigns all the wikis to @wikis' do
            get :index
            expect(assigns(:wikis)).to eq([wiki]) #because Wiki.all returns an array   
        end

        it 'returns http get success' do
            get :index
            expect(response).to have_http_status(:success)
        end

        it 'specifically renders the index view' do
            get :index
            expect(response).to render_template(:index)
        end
    end

end
