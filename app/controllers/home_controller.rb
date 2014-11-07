class HomeController < ApplicationController
	def index
		if user_signed_in?
			if current_user.type == 'Student'
				redirect_to :controller=>"profile", :action => 'index'
			else #employer
				redirect_to :controller=>"companies", :action => 'index'
			end
		end
	end
end