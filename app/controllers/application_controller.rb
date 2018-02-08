class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :markdown
  
  def markdown(text)
    
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true,
      prettify: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      strikethrough: true,
      quote: true
    }

    renderer = Redcarpet::Render::HTML.new(options) #the type of renderer with its options
    markdown = Redcarpet::Markdown.new(renderer, extensions) #the makdown (including that renderer) with its extensions

    #takes the markdown object calls this method on it with the text we passed in
    markdown.render(text).html_safe
  end
  
  
  
  
  
  
  
  private

  def user_not_authorized
    flash[:alert] = "Your account type does not authorize you to perform this action."
    redirect_to(root_path)
  end
end
