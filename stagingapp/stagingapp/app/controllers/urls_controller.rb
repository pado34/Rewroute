class UrlsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :destroy, :edit, :update]
  #can a user create a url for another user? I dont think so but just in case, comment to test later
  before_action :correct_user_url,   only: [:show, :destroy, :edit, :update]

  def show
    @url = current_user.urls.find(params[:id])
  end  
  
  
  
  def new
    @url = current_user.urls.build if logged_in?
	#repetition logged_in already checked with the before action
  end

  def create
	if subscribed?	
		subscriberr = Subscriber.find_by user_id: current_user.id
		if Time.now < subscriberr.subscription_expires_at
		    planid = subscriberr.plan_id
			dis = Plan.find_by id: planid
			if numberofredirects <= dis.maxredirect
				@url = current_user.urls.build(user_params)
				if @url.save
				  flash[:success] = "Url redirection created."
				  redirect_to user_path(current_user)
				else
				  render 'new'
				end				
			else
				flash[:info] = "You've reached your maximum number of redirects."
			end
		else
			flash[:info] = "Your subscription expired, you need to resubscribe."
			redirect_to edit_subscriber_path(current_subscriber_id)		
		end
	else
		if numberofredirects == 0
			@url = current_user.urls.build(user_params)
			if @url.save
			  flash[:success] = "Url redirection created."
			  redirect_to user_path(current_user)
			else
			  render 'new'
			end			
		else
			flash[:info] = "You can create one source->destination mapping maximum, you already have one, if you want more subscribe to a better plan."
			redirect_to user_path(current_user)
		end
	end
  end

  #I dont see why they cant destroy if not subscribed ^^, and number of redirects can only go down so all's good ^^
  def destroy
    @url.destroy
    flash[:success] = "Url redirection deleted."
    redirect_to user_path(current_user)
  end
  
  def edit
    @url = current_user.urls.find(params[:id])
  end

  def update
	if subscribed?	
		subscriberr = Subscriber.find_by user_id: current_user.id
		if Time.now < subscriberr.subscription_expires_at
		    planid = subscriberr.plan_id
			dis = Plan.find_by id: planid
			if numberofredirects <= dis.maxredirect
				@url = current_user.urls.find(params[:id])
				if @url.update_attributes(user_params)
				  # Handle a successful update.
				  flash[:success] = "Url redirection edited"
				  redirect_to user_path(current_user)
				else
				  render 'edit'
				end		
			else
				flash[:info] = "You've reached your maximum number of redirects."
			end
		else
			flash[:info] = "Your subscription expired, you need to resubscribe."
			redirect_to edit_subscriber_path(current_subscriber_id)		
		end
	else
		@url = current_user.urls.find(params[:id])
		if @url.update_attributes(user_params)
		  # Handle a successful update.
		  flash[:success] = "Url redirection edited"
		  redirect_to user_path(current_user)
		else
		  render 'edit'
		end
	end
  end
  
  private

    def user_params
	  params.require(:url).permit(:source, :destination)
    end  
	
    def correct_user_url
      @url = current_user.urls.find_by(id: params[:id])
      redirect_to user_path(current_user) if @url.nil?
    end
	
end