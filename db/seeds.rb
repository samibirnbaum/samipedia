require "random_data"
require 'faker'

5.times do
    user = User.new(
        email: Faker::Internet.unique.free_email,
        password: Faker::Internet.password(8)
    )
    user.skip_confirmation!
    user.save!
end

standard = User.new(
    email: "standard@standard.com", 
    password: "standard"
    )
standard.skip_confirmation!
standard.save!

premium = User.new(
    email: "premium@premium.com", 
    password: "premium"
    )
premium.premium!
premium.skip_confirmation!
premium.save!

admin = User.new(
    email: "admin@admin.com", 
    password: "adminn"
    )
admin.admin!
admin.skip_confirmation!
admin.save!

@users = User.all




10.times do
    Wiki.create!(
        title: Faker::Pokemon.name,
        body: RandomData.random_paragraph,
        private: [1, 0].sample,
        user: @users.sample
    )
end

puts "#{User.all.count} Users Created"
puts "#{Wiki.all.count} Wikis Created"