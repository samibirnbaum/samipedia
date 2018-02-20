class CollaboratorsController < ApplicationController
    
    before_action :authenticate_user!
    before_action :wiki_is_private?
    
    def create
        @collaborator = Collaborator.new
        @wiki = Wiki.find(params[:wiki_id])
        @invite_user = User.find(params[:collaborator][:user][1])
        
        @collaborator.wiki = @wiki
        @collaborator.user = @invite_user

        authorize @collaborator

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

        authorize @collaborator
        
        if @collaborator.delete
            flash[:notice] = "#{@collaborator.user.email} has been removed"
            redirect_to(edit_wiki_path(@wiki.id))
        else
            flash.now[:alert] = "Sorry there was an error removing #{@collaborator.user.email}"
            render "wikis/edit"
        end
    end

    
    
    private
        def wiki_is_private?
            @wiki = Wiki.find(params[:wiki_id])

            if @wiki.private == false
                flash[:alert] = "You can only add or remove collaborators on private wikis"
                redirect_to(edit_wiki_path(@wiki.id))
            end
        end
end
