require "random_data"

5.times do
    user = User.new(
        email: RandomData.random_email,
        password: RandomData.random_sentence
    )
    user.skip_confirmation!
    user.save!
end

member = User.new(
    email: "member@member.com", 
    password: "member"
    )
member.skip_confirmation!
member.save!

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