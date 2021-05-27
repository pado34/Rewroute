class StripeController < ApplicationController

  protect_from_forgery :except => :webhooks

  def webhooks
    event_json = JSON.parse(request.body.read)
    event = Stripe::Event.retrieve(event_json["id"])
    puts "REE"
	if event.type == "customer.subscription.updated"
	  puts "subscription updated osef"
    end


	if event.type == "invoice.payment_succeeded"
	  puts "payment succeeded"
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      if subscriber.plan_id == 5
        ddd= Time.now + 1.day
      else 
        ddd= Time.now + 1.month + 2.days
      end
      subscriber.subscription_expires_at = ddd
      subscriber.save

      Url.where(user_id: subscriber.user_id).update_all(active: 1)
      #also need to send a mail saying the payment has been done every month 
      puts subscriber.user_id
      @ooser = User.find_by(id: subscriber.user_id)
      if @ooser==nil
          puts "nul"
      end
      @ooser.send_paymentsucceeded_email
     
    end


	if event.type == "invoice.payment_failed"
	  puts "payment failed"
      #I need to send a mail here to say payment has failed
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      if subscriber==nil
        puts "kek'd"
      else
        puts "ree'd"
        @ooser = User.find_by(id: subscriber.user_id)
        
        @ooser.send_paymentfailed_email        
      end


    end


	if event.type == "customer.subscription.deleted"
	  puts "subscription deleted and we need to put all active things to 0"
      subscriber = Subscriber.find_by(stripe_customer_id: event.data.object.customer)
      if subscriber==nil
        puts "kek'd"
      else
        puts "ree'd"
        Url.where(user_id: subscriber.user_id).update_all(active: 0)
        subscriber.destroy  
      end
     
    end



    #status 200
    head 200, content_type: "text/html"
    
  end

end


