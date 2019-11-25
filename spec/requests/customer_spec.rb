require "rails_helper"

RSpec.describe CustomerController, type: :request do

    let(:user) { create(:customer) }
    let(:headers) { valid_headers }
    
    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password
      }
    end
    let(:invalid_credentials) do
      {
        email: Faker::Internet.email,
        password: Faker::Internet.password
      }
    end

    after(:each) do
      user.destroy
    end

    describe 'POST /customers/login Login User ' do
        # returns auth token when request is valid
        context 'When request is valid' do
          before { post '/customers/login', params: valid_credentials }
          it 'returns an authentication token' do
            expect(json["message"]).to eq "Login was successful"
          end
        end

        context 'When request is invalid' do
          before { post '/customers/login', params: invalid_credentials }
          it 'returns a failure message' do
            expect(json["error"]).to eq "Invalid credentials"
          end
        end
    end

    describe 'GET retrieve profile ' do
      context 'login in user get profile from token' do
        before { get '/customer', params: {}, headers: headers }
        it 'returns user profile details' do
          expect(json["auth_token"]["name"]).to eq user.name
        end
      end
    end
end