class ChangeplansController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user_subscriber,   only: [:edit, :update]

  def edit
    @vvv = Subscriber.find_by id: params[:id] 
  end

  def update
    #rn
	@subscriber = Subscriber.find_by id: params[:id]    
	customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
	subby = customer.subscriptions.first.id
	subscription = customer.subscriptions.retrieve(subby)
	@ttt = Plan.find_by id: params[:yyy]
	subscription.plan = @ttt.stripe_id
	subscription.save	
    @subscriber.plan_id = @ttt.id
    @subscriber.save
    
	flash[:success] = "Plan changed"
    redirect_to subscriber_path(current_subscriber_id)
  end
  


  private
	
    def correct_user_subscriber	  
	  @subscriber = Subscriber.find_by id: params[:id], user_id: current_user.id
	  
      redirect_to root_path if @subscriber.nil?
    end    
  
  
end
