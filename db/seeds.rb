require "random_data"

5.times do
    User.create!(
        email: RandomData.random_email,
        password: RandomData.random_sentence
    )
end

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