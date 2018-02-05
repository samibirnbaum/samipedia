require 'rails_helper'
require "random_data"

RSpec.describe WikisController, type: :controller do
    let(:my_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }
    let(:wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: my_user) }
    let(:private_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: my_user) }

    let(:other_user) { User.create!(email: RandomData.random_email, password: RandomData.random_sentence) }
    let(:other_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: false, user: other_user) }
    let(:private_other_wiki) { Wiki.create!(title: RandomData.random_sentence, body: RandomData.random_paragraph, private: true, user: other_user) }

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
            it 'redirects guest to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'POST #create' do
            it 'redirects guest to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'GET #edit' do
            it 'redirects guest to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'PUT #update' do
            it 'redirects guest to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end

        describe 'DELETE #destroy' do
            it 'redirects guest to sign in page' do
                #unclear how to test devise #authenticate_user!
            end
        end
    end
    
    
    
    
    
    
    
    
    context "standard user" do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = my_user #standard role by default
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

        #standard user can only create public wikis
        describe 'POST #create' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'redirects standard user back to home page' do
                    post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #show' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'redirects standard user back to home page' do
                    get :show, params: {id: private_wiki.id}
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'GET #edit' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'unauthorized, redirected to root page' do
                    get :edit, params: {id: private_wiki.id}
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'PUT #update' do
            context 'update public wiki keeping it public' do
                it 'assigns to @wiki the wiki with the id in url' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).id).to eq(wiki.id)
                end

                it 'assigns @wiki the new updated values' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).title).to eq("updated")
                    expect(assigns(:wiki).body).to eq("new updated body")
                    expect(assigns(:wiki).private).to eq(false)
                end

                it 'redirects user to show view' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(response).to redirect_to(wiki_path(wiki.id))
                end
            end

            context 'update public wiki trying to make it private' do
                it 'does something' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: true}}
                    expect(response).to redirect_to(root_path)
                end
            end
        end

        describe 'DELETE #destroy' do
            context 'on own wiki' do
                it 'assigns to @wiki the wiki with id in url to delete' do
                    delete :destroy, params: {id: wiki.id} #signed in as my_user i own this wiki
                    expect(assigns(:wiki)).to eq(wiki)
                end

                it 'deletes that wiki from the datbase' do
                    delete :destroy, params: {id: wiki.id}
                    expect(Wiki.where(id: wiki.id)).to eq([])
                end

                it 'redirects user to the wiki home page' do
                    delete :destroy, params: {id: wiki.id}
                    expect(response).to redirect_to(wikis_path)
                end
            end

            context 'on someone elses wiki' do
                it 'redirects user back to root page' do
                    delete :destroy, params: {id: other_wiki.id}
                    expect(response).to redirect_to(root_path)
                end
            end
        end
    end

    context 'premimum user' do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = my_user
            user.premium!
            user.confirm
            sign_in user
        end

        describe 'GET #index' do
            it 'assigns all the wikis to @wikis' do
                get :index
                expect(assigns(:wikis)).to eq([wiki])  
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
            context 'public wiki' do
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

            context 'private wiki' do
                it 'assigns params passed in to our new @wiki object' do
                    post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}
                    expect(assigns(:wiki).title).to eq("title")
                    expect(assigns(:wiki).body).to eq("the body of our new wiki")
                    expect(assigns(:wiki).private).to eq(true)
                    expect(assigns(:wiki).user_id).to eq(my_user.id)
                end

                it 'saves that wiki object to the database' do
                    expect {post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}}.to change{Wiki.all.count}.by(1)
                end

                it 'redirects user to the show page' do
                    post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}
                    expect(response).to redirect_to(wiki_path(my_user.wikis.last.id))
                end
            end
        end

        describe 'GET #show' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'gets the right wiki from the datbase and assigns it to @wiki base on params id' do
                    get :show, params: {id: private_wiki.id}
                    expect(assigns(:wiki)).to eq(private_wiki)
                end
                
                it 'returns http get success' do
                    get :show, params: {id: private_wiki.id}
                    expect(response).to have_http_status(:success)
                end

                it 'specifically renders the show view' do
                    get :show, params: {id: private_wiki.id}
                    expect(response).to render_template(:show)
                end
            end
        end

        describe 'GET #edit' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'assigns to @wiki the wiki from the database whos param you passed in' do
                    get :edit, params: {id: private_wiki.id}
                    expect(assigns(:wiki)).to eq(private_wiki)
                end

                it 'returns http get success' do
                    get :edit, params: {id: private_wiki.id}
                    expect(response).to have_http_status(:success)
                end

                it 'specifically renders the index view' do
                    get :edit, params: {id: private_wiki.id}
                    expect(response).to render_template(:edit)
                end
            end
        end

        describe 'PUT #update' do
            context 'update public wiki' do
                it 'assigns to @wiki the wiki with the id in url' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).id).to eq(wiki.id)
                end

                it 'assigns @wiki the new updated values' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).title).to eq("updated")
                    expect(assigns(:wiki).body).to eq("new updated body")
                    expect(assigns(:wiki).private).to eq(false)
                end

                it 'redirects user to show view' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(response).to redirect_to(wiki_path(wiki.id))
                end
            end

            context 'update private wiki' do
                it 'assigns to @wiki the wiki with the id in url' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).id).to eq(wiki.id)
                end

                it 'assigns @wiki the new updated values' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).title).to eq("updated")
                    expect(assigns(:wiki).body).to eq("new updated body")
                    expect(assigns(:wiki).private).to eq(false)
                end

                it 'redirects user to show view' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(response).to redirect_to(wiki_path(wiki.id))
                end
            end

            context 'update public wiki not your own changing private status' do
                it "redirects you to root page" do
                    put :update, params: {id: other_wiki.id, wiki: {title: "updated", body: "new updated body", private: true}} #changed from false to true
                    expect(response).to redirect_to(root_path)
                end
            end
        end

            context 'update private wiki not your own changing private status' do
                it "redirects you to root page" do
                    put :update, params: {id: private_other_wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(response).to redirect_to(root_path)
                end
            end

        describe 'DELETE #destroy' do
            context 'on own wiki' do
                it 'assigns to @wiki the wiki with id in url to delete' do
                    delete :destroy, params: {id: wiki.id} #signed in as my_user i own this wiki
                    expect(assigns(:wiki)).to eq(wiki)
                end

                it 'deletes that wiki from the datbase' do
                    delete :destroy, params: {id: wiki.id}
                    expect(Wiki.where(id: wiki.id)).to eq([])
                end

                it 'redirects user to the wiki home page' do
                    delete :destroy, params: {id: wiki.id}
                    expect(response).to redirect_to(wikis_path)
                end
            end

            context 'on someone elses wiki' do
                it 'redirects user back to root page' do
                    delete :destroy, params: {id: other_wiki.id}
                    expect(response).to redirect_to(root_path)
                end
            end
        end
    end

    
    
    
    
    
    
    context 'admin user' do
        before do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            user = my_user
            user.admin!
            user.confirm
            sign_in user
        end

        describe 'GET #index' do
            it 'assigns all the wikis to @wikis' do
                get :index
                expect(assigns(:wikis)).to eq([wiki])  
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
            context 'public wiki' do
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

            context 'private wiki' do
                it 'assigns params passed in to our new @wiki object' do
                    post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}
                    expect(assigns(:wiki).title).to eq("title")
                    expect(assigns(:wiki).body).to eq("the body of our new wiki")
                    expect(assigns(:wiki).private).to eq(true)
                    expect(assigns(:wiki).user_id).to eq(my_user.id)
                end

                it 'saves that wiki object to the database' do
                    expect {post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}}.to change{Wiki.all.count}.by(1)
                end

                it 'redirects user to the show page' do
                    post :create, params: {wiki: {title: "title", body: "the body of our new wiki", private: true}}
                    expect(response).to redirect_to(wiki_path(my_user.wikis.last.id))
                end
            end
        end

        describe 'GET #show' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'gets the right wiki from the datbase and assigns it to @wiki base on params id' do
                    get :show, params: {id: private_wiki.id}
                    expect(assigns(:wiki)).to eq(private_wiki)
                end
                
                it 'returns http get success' do
                    get :show, params: {id: private_wiki.id}
                    expect(response).to have_http_status(:success)
                end

                it 'specifically renders the show view' do
                    get :show, params: {id: private_wiki.id}
                    expect(response).to render_template(:show)
                end
            end
        end

        describe 'GET #edit' do
            context 'public wiki' do
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

            context 'private wiki' do
                it 'assigns to @wiki the wiki from the database whos param you passed in' do
                    get :edit, params: {id: private_wiki.id}
                    expect(assigns(:wiki)).to eq(private_wiki)
                end

                it 'returns http get success' do
                    get :edit, params: {id: private_wiki.id}
                    expect(response).to have_http_status(:success)
                end

                it 'specifically renders the index view' do
                    get :edit, params: {id: private_wiki.id}
                    expect(response).to render_template(:edit)
                end
            end
        end

        describe 'PUT #update' do
            context 'update public wiki keeping it public' do
                it 'assigns to @wiki the wiki with the id in url' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).id).to eq(wiki.id)
                end

                it 'assigns @wiki the new updated values' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(assigns(:wiki).title).to eq("updated")
                    expect(assigns(:wiki).body).to eq("new updated body")
                    expect(assigns(:wiki).private).to eq(false)
                end

                it 'redirects user to show view' do
                    put :update, params: {id: wiki.id, wiki: {title: "updated", body: "new updated body", private: false}}
                    expect(response).to redirect_to(wiki_path(wiki.id))
                end
            end

            context 'update public wiki to private ANYONES' do
                it 'assigns to @wiki the wiki with the id in url' do
                    put :update, params: {id: other_wiki.id, wiki: {title: "updated", body: "new updated body", private: true}}
                    expect(assigns(:wiki).id).to eq(other_wiki.id)
                end

                it 'assigns @wiki the new updated values' do
                    put :update, params: {id: other_wiki.id, wiki: {title: "updated", body: "new updated body", private: true}}
                    expect(assigns(:wiki).title).to eq("updated")
                    expect(assigns(:wiki).body).to eq("new updated body")
                    expect(assigns(:wiki).private).to eq(true)
                end

                it 'redirects user to show view' do
                    put :update, params: {id: other_wiki.id, wiki: {title: "updated", body: "new updated body", private: true}}
                    expect(response).to redirect_to(wiki_path(other_wiki.id))
                end
            end
        end

        describe 'DELETE #destroy' do
            context 'admin on own wiki' do
                it 'assigns to @wiki the wiki with id in url to delete' do
                    delete :destroy, params: {id: wiki.id} #signed in as my_user i own this wiki
                    expect(assigns(:wiki)).to eq(wiki)
                end

                it 'deletes that wiki from the datbase' do
                    delete :destroy, params: {id: wiki.id}
                    expect(Wiki.where(id: wiki.id)).to eq([])
                end

                it 'redirects user to the wiki home page' do
                    delete :destroy, params: {id: wiki.id}
                    expect(response).to redirect_to(wikis_path)
                end
            end

            context 'admin on someone elses wiki' do
                it 'assigns to @wiki the wiki with id in url to delete' do
                    delete :destroy, params: {id: other_wiki.id} #signed in as my_user i own this wiki
                    expect(assigns(:wiki)).to eq(other_wiki)
                end

                it 'deletes that wiki from the datbase' do
                    delete :destroy, params: {id: other_wiki.id}
                    expect(Wiki.where(id: other_wiki.id)).to eq([])
                end

                it 'redirects user to the wiki home page' do
                    delete :destroy, params: {id: other_wiki.id}
                    expect(response).to redirect_to(wikis_path)
                end
            end
        end
    end
end
