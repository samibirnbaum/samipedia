require 'rails_helper'

RSpec.describe Wiki, type: :model do
    let(:my_user) {User.create!(email: "s@gmail.com", password: "password") }
    let(:wiki) {Wiki.create!(title: "wiki title", body: "wiki bodyaaaaaaa", private: false, user: my_user)}
    
    describe 'wiki model' do
        it 'has attributes' do
            expect(wiki).to have_attributes(title: "wiki title", body: "wiki bodyaaaaaaa", private: false, user: my_user)
        end

        it { should belong_to(:user) }
        it { should have_many(:collaborators) }
        it { should have_many(:users).through(:collaborators) }

        it { should validate_presence_of(:title) }
        it { should validate_presence_of(:body) }

        it { should validate_length_of(:title).is_at_least(3) }
        it { should validate_length_of(:body).is_at_least(15) }
    end
end
