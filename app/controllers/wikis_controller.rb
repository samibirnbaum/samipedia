class WikisController < ApplicationController
    def index
        @wikis = Wiki.all
    end

    def show
        
    end
end
