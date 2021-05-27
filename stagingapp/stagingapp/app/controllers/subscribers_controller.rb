class SubscribersController < ApplicationController

  before_action :logged_in_user, only: [:show, :new, :create, :destroy, :edit, :update]
  before_action :correct_user_subscriber,   only: [:show, :destroy, :edit, :update]
  

  
  def show
    @user = User.find(current_user.id)
	@subscriber = Subscriber.find_by id: params[:id]
	@subscriberr = Subscriber.find_by id: params[:id], user_id: current_user.id
  end  
  



  def destroy
	customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
	sub_id = customer["subscriptions"]["data"][0]["id"]
	
    customer.subscriptions.retrieve(sub_id).delete 
	
	Url.where(user_id: @subscriber.user_id).update_all(active: 0)

	@subscriber.destroy
	
    flash[:success] = "Unsubscribed"	
	redirect_to new_subscriber_path
  end


  
  
  
  def new
    @subscriber = Subscriber.new
  end

  def create
	@plan = Plan.find_by id: params[:plan]
    stripe_token = params[:stripeToken]
	
    begin
      customer = Stripe::Customer.create(
        source: stripe_token,
        plan: @plan.stripe_id,
        email: current_user.email,
      )
	  
	  d=Time.now
	  dd=d+ 1.month 
      #give a lil bit of leeway, stripe takes time to send all the webhooks so better safe than sorry
      dd=dd+ 2.days
	  @subscriber = Subscriber.new(:stripe_customer_id => customer.id, :plan_id => @plan.id, :user_id => current_user.id, :subscribed_at => d, :subscription_expires_at => dd)
	  
	  
	  @subscriber.save!(validate: false)  
	  redirect_to subscriber_path(current_subscriber_id)
	  
    rescue Stripe::CardError => e
      errors.add :credit_card, e.message
      false
    end

  end

  
  
  
  
  def edit
    @subscriber = Subscriber.find_by id: params[:id]
  end

  def update
    stripe_token = params[:stripeToken]
	@subscriber = Subscriber.find_by id: params[:id]
    begin
	  customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
      card = customer.sources.create(source: stripe_token)
	  customer.default_source = card.id
	  customer.save
      flash[:success] = "Card updated"
      redirect_to subscriber_path(current_subscriber_id)
	#check if this rescuing error works some time
    rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while updating card info: #{e.message}"
      errors.add :base, "#{e.message}"
      false
	end
  end 
  
  
  

  private
	
    def correct_user_subscriber	  
	  @subscriber = Subscriber.find_by id: params[:id], user_id: current_user.id
	  
      redirect_to root_path if @subscriber.nil?
    end  
  
  
  
end