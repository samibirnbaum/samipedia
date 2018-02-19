require "random_data"
require 'faker'

5.times do
    user = User.new(
        email: Faker::Internet.unique.free_email,
        password: Faker::Internet.password(8),
        role: ["standard", "premium", "standard"].sample
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

Wiki.all.each do |wiki|
    if wiki.user.standard?
        wiki.update_attribute(:private, 0)
    end
    if wiki.user.premium?
        3.times {Collaborator.create!(wiki: wiki, user: @users.sample)}
    end
end




puts "#{User.all.count} Users Created\n\n"
premium_count = 0
standard_count = 0
admin_count = 0
User.all.each do|user|  
    if user.premium?
        premium_count = premium_count + 1
    elsif user.standard?
        standard_count = standard_count + 1
    elsif user.admin?
        admin_count = admin_count + 1
    end
end
puts "#{standard_count} standard users"
puts "#{premium_count} premium users"
puts "#{admin_count} admin user \n\n"

puts "#{Wiki.all.count} Wikis Created\n\n"
Wiki.all.each {|wiki| puts "#{wiki.title} premium owned!" if wiki.user.premium?}
puts

puts "#{Collaborator.all.count} Collaborators Created for premium owned wikis"
