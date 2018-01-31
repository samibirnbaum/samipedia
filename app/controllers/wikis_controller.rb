class WikisController < ApplicationController

    before_action :authenticate_user!, except: [:index, :show]

    def index
        @wikis = Wiki.all
    end

    def show
        @wiki = Wiki.find(params[:id])
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
end
