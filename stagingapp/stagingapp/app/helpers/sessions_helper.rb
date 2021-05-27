module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
	  
      user = User.find_by(id: user_id)
	  if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end  

  # Returns true if the given user is subscribed to the(a) plan.
  def subscribed?
    bla = Subscriber.find_by user_id: current_user.id
	!bla.nil?
  end 

  # Returns the number of redirects of a user. 
  def numberofredirects
    #number = Url.find_by(user_id: current_user.id).distinct.count(:destination) doesn't work for some reason oh welp 
	#number = Url.select(user_id: current_user.id).distinct.count(:destination) doesnt work now wtf?

    number = Url.where(user_id: current_user.id).distinct.count(:destination)
	puts "ici"
	puts number
	return number
  end   
  
  
  # Returns true if the given user is the current user.
  def current_subscriber_id
    blo = Subscriber.find_by user_id: current_user.id
	id = blo.id
  end 
  
  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end  
  
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end  
 
  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end 
  
  
  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end  
end