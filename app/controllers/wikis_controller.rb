class WikisController < ApplicationController

    before_action :authenticate_user!, except: [:index, :show]
    before_action :wiki_owner?, only: [:destroy]

    def index
        @wikis = Wiki.all
    end

    def show
        @wiki = Wiki.find(params[:id])
        authorize @wiki
    end

    def new
        @wiki = Wiki.new
    end

    def create
        @wiki = Wiki.new
        @wiki.title = params[:wiki][:title]
        @wiki.body = params[:wiki][:body]
        @wiki.private = params[:wiki][:private]
        @wiki.user_id = current_user.id

        authorize @wiki #checks wiki policy

        if @wiki.save
            flash[:notice] = "Your new wiki has been successfully saved!"
            redirect_to(wiki_path(@wiki.id))
        else
            flash[:alert] = "There was an error creating your wiki. Please try again."
            render :new
        end
    end

    def edit
        @wiki = Wiki.find(params[:id])
    end

    def update
        @wiki = Wiki.find(params[:id])
        @wiki.title = params[:wiki][:title]
        @wiki.body = params[:wiki][:body]
        @wiki.private = params[:wiki][:private]

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

        if @wiki.delete
            flash[:notice] = "Wiki successfully deleted!"
            redirect_to(wikis_path)
        else
            flash[:alert] = "There was an error deleting your wiki. Please try again."
            render :show
        end
    end

    private
        def wiki_owner?
            @wiki = Wiki.find(params[:id])

            if @wiki.user != current_user
                flash[:alert] = "You can only delete a wiki you own"
                redirect_to(wiki_path(@wiki.id))
            end 
        end
end
