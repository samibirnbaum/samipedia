class WikisController < ApplicationController

    def index
        @wikis = policy_scope(Wiki)
    end

    def show
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end

    def new
        authorize Wiki
        @wiki = Wiki.new
    end

    def create
        @wiki = Wiki.new(wiki_params)
        @wiki.user_id = current_user.id

        authorize @wiki

        if @wiki.save
            Collaborator.create(user: @wiki.user, wiki: @wiki)
            flash[:notice] = "Your new wiki has been successfully saved!"
            redirect_to(wiki_path(@wiki.id))
        else
            flash[:alert] = "There was an error creating your wiki. Please try again."
            render :new
        end
    end

    def edit
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end

    def update
        @wiki = Wiki.find(params[:id])
        @wiki.update_attributes(wiki_params)

        authorize @wiki

        if @wiki.save
            flash[:notice] = "Wiki successfully updated!"
            redirect_to(wiki_path(@wiki.id))
        else
            flash[:alert] = "There was an error updating wiki. Please try again."
            render :edit
        end
    end

    def destroy
        @wiki = Wiki.find(params[:id])

        authorize @wiki

        if @wiki.delete
            flash[:notice] = "Wiki successfully deleted!"
            redirect_to(wikis_path)
        else
            flash[:alert] = "There was an error deleting your wiki. Please try again."
            render :show
        end
    end

    private
        def wiki_params
            params.require(:wiki).permit(:title, :body, :private)
        end
end
