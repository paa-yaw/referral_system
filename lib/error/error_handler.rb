module Error
  module ErrorHandler
    def self.included base 
      base.class_eval do 
      	# rescue_from StandardError, with: :unknown_error
        # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        # rescue_from ActionController::RoutingError, with: :routing_error
      end
    end

    def routing_error
      flash[:alert] = "error: you tried navigating a route that does not exist."
      if current_user.admin?
      	redirect_to admin_dashboard_url
      else	
        redirect_to root_url
      end  
    end

    private 

    def unknown_error(exception)
      flash[:alert] = "oops! something went Error: wrong #{exception}."
      if current_user.admin?
      	redirect_to admin_dashboard_url
      else	
        redirect_to root_url
      end  
        	
    end

    def record_not_found
      flash[:alert] = "the resource you are looking for doesn't exist."
      if current_user.admin?
      	redirect_to admin_dashboard_url
      else	
        redirect_to root_url
      end  
    end
  end
end