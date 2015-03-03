class DashboardController < ApplicationController

before_action :authenticate_user!




  def index
  

	if current_user.admin?
 		@user = User.all

 	else 
 		render plain: "Error"
	end


  end

end
