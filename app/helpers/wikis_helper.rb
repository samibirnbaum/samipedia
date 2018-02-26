module WikisHelper
    def relationship_to_wiki(wiki, current_user)
        if wiki.user == current_user
            '<mark style="color:gray;">You own this Wiki</mark> <br>'.html_safe
        elsif wiki.private == false
            '<mark style="color:gray;">Public Wiki</mark> <br>'.html_safe
        elsif wiki.collaborators.where(user: current_user).any?
            '<mark style="color:gray;">Collaborater of Wiki</mark> <br>'.html_safe
        else
            '<mark style="color:gray;">Private Wiki</mark> <br>'.html_safe
        end
    end
end
