require 'rails_helper'

RSpec.describe ProductController, type: :request do
  let(:user) { create(:customer) }
  let(:headers) { valid_headers }

  after(:each) do
    user.destroy
  end

  describe 'Product Controller' do

    # get all shipping
    context 'GET get all shipping regions' do
      before { get "/shipping/regions", headers: headers}
      it 'should get all shipping regions' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
    
    # get a single shipping region 
    context 'GET get a single shipping region ' do
      before { get "/shipping/regions/2", headers: headers}
      it 'should get a single shipping region ' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end

  end
end
