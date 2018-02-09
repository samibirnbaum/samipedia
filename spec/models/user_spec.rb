require 'rails_helper'

RSpec.describe User, type: :model do
    #a lot through devise and tested by devise
    let(:user) {User.create!(email: "s@gmail.com", password: "password")}
  
    describe "attrbiutes" do
        it 'has attributes' do
            expect(user).to have_attributes(email: "s@gmail.com", password: "password")
        end

        it { should have_many(:wikis) }
        it { should have_many(:collaborators) }
        it { should have_many(:wikis).through(:collaborators) }
    end

    describe 'Role Attribute' do
        it 'responds to role' do
            expect(user).to respond_to(:role)
        end

        it 'responds to standard?' do
            expect(user).to respond_to(:standard?)
        end

        it 'responds to premium?' do
            expect(user).to respond_to(:premium?)
        end

        it 'responds to admin' do
            expect(user).to respond_to(:admin?)
        end

        context 'standard user' do
            it 'user should have standard role by default' do
                expect(user.role).to eq("standard")    
            end

            it 'standard? should be true' do
                expect(user.standard?).to be_truthy
            end

            it 'premium? should be false' do
                expect(user.premium?).to be_falsey
            end

            it 'admin? should be false' do
                expect(user.admin?).to be_falsey
            end
        end

        context 'premium user' do
            before do
              user.premium!
            end
            it 'standard? should be false' do
                expect(user.standard?).to be_falsey
            end

            it 'premium? should be true' do
                expect(user.premium?).to be_truthy
            end

            it 'admin? should be false' do
                expect(user.admin?).to be_falsey
            end
        end

        context 'admin user' do
            before do
                user.admin!
            end
            it 'standard? should be false' do
                expect(user.standard?).to be_falsey
            end

            it 'premium? should be false' do
                expect(user.premium?).to be_falsey
            end

            it 'admin? should be true' do
                expect(user.admin?).to be_truthy
            end
        end
    end
end
