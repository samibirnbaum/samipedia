require 'rails_helper'

RSpec.describe CollaboratorsController, type: :controller do
    let(:my_user) {User.create!(email: "s@sami.com", password: "password", role: "premium")}
    let(:my_wiki) {Wiki.create!(title: "asd", body: "aaaaaaaaaaaaaaaaaaa", private: true, user: my_user)}
    let(:invite_user) {User.create!(email: "m@mike.com", password: "password", role: "standard")}
    let(:my_collaborator) {Collaborator.create!(user: invite_user, wiki:my_wiki)}
    
    
    describe 'POST #create' do
        context 'standard user' do
          #cant access private wikis anyway
        end

        context 'premium user' do
            before do
                @request.env["devise.mapping"] = Devise.mappings[:user]
                user = my_user
                user.confirm
                sign_in user
            end

            it 'assigns correct invited user to @user and correct wiki to @wiki' do
                post :create, params: {wiki_id: my_wiki.id, collaborator: {user: ["", invite_user.id]}}
                expect(assigns(:wiki)).to eq(my_wiki)
                expect(assigns(:invite_user)).to eq(invite_user)
            end

            it 'saves new collaboration object to the database' do
                expect {post :create, params: {wiki_id: my_wiki.id, collaborator: {user: ["", invite_user.id]}}}.to change{Collaborator.all.count}.by(1)
            end

            it 'redirects user back to wiki edit page' do
                post :create, params: {wiki_id: my_wiki.id, collaborator: {user: ["", invite_user.id]}}
                expect(response).to redirect_to(edit_wiki_path(my_wiki.id))
            end
        end

        context 'admin user' do
          
        end
    end

    describe 'DELETE #destroy' do
        context 'standard user' do
            #cant access private wikis anyway
        end
        
        context 'premium user' do
            before do
                @request.env["devise.mapping"] = Devise.mappings[:user]
                user = my_user
                user.confirm
                sign_in user
            end

            it 'assigns the correct collaborator object to @collaborator' do
                delete :destroy, params: {wiki_id: my_wiki, id: my_collaborator.id}
                expect(assigns(:collaborator)).to eq(my_collaborator)
            end

            it 'searching the databse for that collaborator model returns nothing' do
                delete :destroy, params: {wiki_id: my_wiki, id: my_collaborator.id}
                expect(Collaborator.where(id: my_collaborator.id)).to eq([])
            end

            it 'redirects user back to wiki edit page' do
                delete :destroy, params: {wiki_id: my_wiki, id: my_collaborator.id}
                expect(response).to redirect_to(edit_wiki_path(my_wiki.id))
            end
        end

        context 'admin user' do
          
        end
    end
end
