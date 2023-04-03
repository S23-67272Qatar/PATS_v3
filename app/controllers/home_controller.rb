class HomeController < ApplicationController
  # This controller is created to handle static pages request
  # It does not have a model associated with it
  # hence, its actions display templates only!
  # It is created to handle any home page content.So, we do not need
  # to control the authentication
  # The pages handled by this controller could all be consulted by anyone
  # including guests.

  def index
    # render template:index.html.erb, layout: application.html.erb
  end

  def about
    # render template:about.html.erb, layout: application.html.erb
  end

  def contact
    # render template:contact.html.erb, layout: application.html.erb
  end

  def privacy
    # render template:privacy.html.erb, layout: application.html.erb
  end
  
end



































# def search
#   redirect_back(fallback_location: home_path) if params[:query].blank?
#   @query = params[:query]
#   @owners = Owner.search(@query)
#   @pets = Pet.search(@query)
#   @total_hits = @owners.size + @pets.size
# end