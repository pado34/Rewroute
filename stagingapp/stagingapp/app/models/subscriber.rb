class Subscriber < ApplicationRecord

  belongs_to :user
  belongs_to :plan

  def save_and_make_payment(plan, card_token, email)
    puts "ree"
    self.plan = plan

	puts "tee"
    begin
      customer = Stripe::Customer.create(
        source: card_token,
        plan: plan.stripe_id,
        email: email,
      )
      self.stripe_customer_id = customer.id
      save(validate: false)
    rescue Stripe::CardError => e
      errors.add :credit_card, e.message
      false
    end
  
  end
  
  

end