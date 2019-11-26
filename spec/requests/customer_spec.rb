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

    describe 'POST Login User ' do
        # returns auth token when request is valid
        context 'When request is valid' do
          before { post '/customers/login', params: valid_credentials }
          it 'returns an authentication token' do
            expect(response).to have_http_status(200)
            expect(json["message"]).to eq "Login was successful"
          end
        end

        context 'When request is invalid' do
          before { post '/customers/login', params: invalid_credentials }
          it 'returns a failure message' do
            expect(response).to have_http_status(404)
            expect(json["error"]).to eq "Invalid credentials"
          end
        end
    end

    describe 'GET retrieve profile ' do
      context 'login in user get profile from token' do
        before { get '/customer', params: {}, headers: headers }
        it 'returns user profile details' do
          expect(response).to have_http_status(200)
          expect(json["auth_token"]["name"]).to eq user.name
        end
      end
    end


    ## name, email, password, day_phone, eve_phone and mob_phone
    describe 'PUT  update customer profile' do
      before do
        @customer = {
          name: user.name, 
          email: user.email,
          password: user.password, 
          day_phone: "8023456768",
          eve_phone: "8023456768", 
          mob_phone: "8023456768"
        }
      end
      context 'update_customer_profile' do
        before { put '/customer', params: @customer.to_json, headers: headers }
        it 'returns user updated details' do
          expect(response).to have_http_status(200)
          expect(json["day_phone"]).to eq @customer[:day_phone]
          expect(json["eve_phone"]).to eq @customer[:eve_phone]
          expect(json["mob_phone"]).to eq @customer[:mob_phone]
        end
      end
    end


     # update a customer billing info such as
  # address_1, address_2, city, region, postal_code, country and shipping_region_id
    describe 'PUT update customer billing info ' do
      before do
        @customer_address = {
          "address_1": "5 tiamiyiu",
          "address_2": "5 tiamiyiu",
          "city": "maryland",
          "region": "lagos",
          "postal_code":1234,
          "country": "Nigeria",
          "shipping_region_id": 1
        }
        @invalid_customer_address = {
          "address_1": "",
          "address_2": "5 tiamiyiu",
          "city": "maryland",
          "region": "lagos",
          "postal_code":1234,
          "country": "Nigeria",
          "shipping_region_id": 1
        }.to_json
      end
      context 'update_customer_profile' do
        before { put '/customer/address', params: @customer_address.to_json, headers: headers }
        it 'returns user updated billing info' do
          expect(response).to have_http_status(200)
          expect(json["postal_code"]).to eq @customer_address[:postal_code].to_json
          expect(json["shipping_region_id"]).to eq @customer_address[:shipping_region_id]
          expect(json["region"]).to eq @customer_address[:region]
        end
      end

      context 'update_customer_profile' do
        before { put '/customer/address', params: @invalid_customer_address, headers: headers }
        it 'returns error' do
          expect(response).to have_http_status(400)

        end
      end
    end
end