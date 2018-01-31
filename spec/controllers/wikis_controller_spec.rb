require 'rails_helper'
require "random_data"

RSpec.describe WikisController, type: :controller do
    let(:my_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }
    let(:wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }
    
    context "guest" do
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

        describe 'GET #show' do
            it 'gets the right wiki from the datbase and assigns it to @wiki base on params id' do
                get :show, params: {id: wiki.id}
                expect(assigns(:wiki)).to eq(wiki)
            end
            
            it 'returns http get success' do
                get :show, params: {id: wiki.id}
                expect(response).to have_http_status(:success)
            end

            it 'specifically renders the show view' do
                get :show, params: {id: wiki.id}
                expect(response).to render_template(:show)
            end
        end

        describe 'GET #new' do
            it 'redirects user to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'POST #create' do
            it 'assigns params passed in to our new @wiki object' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'GET #edit' do
            it 'redirects user to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end
    end
    
    
    
    
    
    
    
    
    context "member" do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = my_user
            user.confirm
            sign_in user
        end
        
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

        describe 'GET #show' do
            it 'gets the right wiki from the datbase and assigns it to @wiki base on params id' do
                get :show, params: {id: wiki.id}
                expect(assigns(:wiki)).to eq(wiki)
            end
            
            it 'returns http get success' do
                get :show, params: {id: wiki.id}
                expect(response).to have_http_status(:success)
            end

            it 'specifically renders the show view' do
                get :show, params: {id: wiki.id}
                expect(response).to render_template(:show)
            end
        end

        describe 'GET #new' do
            it 'assigns a new wiki object to @wiki' do
                get :new
                expect(assigns(:wiki)).to be_an_instance_of(Wiki)
            end
            
            it 'returns http get success' do
                get :new
                expect(response).to have_http_status(:success)
            end

            it 'specifically renders the index view' do
                get :new
                expect(response).to render_template(:new)
            end
        end

        describe 'POST #create' do
            it 'assigns params passed in to our new @wiki object' do
                post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: false}}
                expect(assigns(:wiki).title).to eq("title")
                expect(assigns(:wiki).body).to eq("the body of our new wiki")
                expect(assigns(:wiki).private).to eq(false)
                expect(assigns(:wiki).user_id).to eq(my_user.id)
            end

            it 'saves that wiki object to the database' do
                expect {post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: false}}}.to change{Wiki.all.count}.by(1)
            end

            it 'redirects user to the show page' do
                post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: false}}
                expect(response).to redirect_to(wiki_path(my_user.wikis.last.id))
            end
        end

        describe 'GET #edit' do
            it 'assigns to @wiki the wiki from the database whos param you passed in' do
                get :edit, params: {id: wiki.id}
                expect(assigns(:wiki)).to eq(wiki)
            end

            it 'returns http get success' do
                get :edit, params: {id: wiki.id}
                expect(response).to have_http_status(:success)
            end

            it 'specifically renders the index view' do
                get :edit, params: {id: wiki.id}
                expect(response).to render_template(:edit)
            end
        end
    end
end
