require "random_data"

5.times do
    user = User.new(
        email: RandomData.random_email,
        password: RandomData.random_sentence
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
        title: RandomData.random_sentence,
        body: RandomData.random_paragraph,
        private: false,
        user: @users.sample
    )
end

puts "#{User.all.count} Users Created"
puts "#{Wiki.all.count} Wikis Created"