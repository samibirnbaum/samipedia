class CollaboratorsController < ApplicationController
    #before actio require sign in
    def create
        @collaborator = Collaborator.new
        @wiki = Wiki.find(params[:wiki_id])
        @invite_user = User.find(params[:collaborator][:user][1])
        
        @collaborator.wiki = @wiki
        @collaborator.user = @invite_user

        if @collaborator.save
            flash[:notice] = "You have added #{@collaborator.user.email} as a collaborator"
            redirect_to(edit_wiki_path(@wiki.id))
        else
            flash.now[:alert] = "Sorry there was an error: #{@collaborator.errors.messages[:user_id][0]}"
            render "wikis/edit"
        end
    end

    def destroy
        @collaborator = Collaborator.find(params[:id])
        @wiki = Wiki.find(params[:wiki_id])

        if @collaborator.delete
            flash[:notice] = "#{@collaborator.user.email} has been removed"
            redirect_to(edit_wiki_path(@wiki.id))
        else
            flash.now[:alert] = "Sorry there was an error removing #{@collaborator.user.email}"
            render "wikis/edit"
        end
    end
end
