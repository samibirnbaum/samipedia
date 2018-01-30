require 'rails_helper'

RSpec.describe User, type: :model do
    #a lot through devise and tested by devise
    let(:user) {User.create!(email: "s@gmail.com", password: "password")}
  
    describe "user model" do
        it 'has attributes' do
            expect(user).to have_attributes(email: "s@gmail.com", password: "password")
        end

        it { should have_many(:wikis) }
    end
end
