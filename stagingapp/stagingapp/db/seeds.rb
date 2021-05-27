# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
			 
User.create!(name:  "sockse",
             email: "sooox@frenmail.org",
             password:              "mettreunmotdepasseici",
             password_confirmation: "mettreunmotdepasseici",
			 admin: true,
             activated: true,
             activated_at: Time.zone.now)
			 
User.create!(name:  "chara",
             email: "chara@frenmail.org",
             password:              "mettreunmotdepasseici",
             password_confirmation: "mettreunmotdepasseici",
			 admin: false,
             activated: true,
             activated_at: Time.zone.now)




Plan.create(name: "Personal", stripe_id: "planid", display_price: 2, maxredirect: 10)
Plan.create(name: "Professional", stripe_id: "planid", display_price: 10, maxredirect: 50)
Plan.create(name: "Business", stripe_id: "planid", display_price: 20, maxredirect: 100)
Plan.create(name: "Big business", stripe_id: "planid", display_price: 50, maxredirect: 300)
#this is for testingpurposes only so not in the seeds file hay
Plan.create(name: "testingpurposes", stripe_id: "planid", display_price: 1, maxredirect: 5)