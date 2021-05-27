class CreateSubscribers < ActiveRecord::Migration[5.1]
  def change
    create_table :subscribers do |t|
      t.string :stripe_customer_id, null: false
      t.datetime :subscribed_at, null: false
      t.datetime :subscription_expires_at, null: false
      t.integer :plan_id, null: false
      t.references :user, foreign_key: true, index: { unique: true }, null: false
      t.references :plan, foreign_key: true, null: false
      #2 lines above were this before :
      #t.references :user, foreign_key: true
      #t.references :plan, foreign_key: true 
	  
      t.timestamps
    end
    add_index :subscribers, :plan_id, name: "plans_for_subsribers"
    add_index :subscribers, :subscribed_at, name: "subscribed_at_for_subscribers"
    add_index :subscribers, :subscription_expires_at, name: "expiring_subscritions_on_subscribers"	
  end
end