require 'rails_helper'

RSpec.describe ProductController, type: :request do
  let(:user) { create(:customer) }
  let(:headers) { valid_headers }

  after(:each) do
    user.destroy
  end

  describe 'Product Controller' do

    # get all categories
    context 'GET get all categories' do
      before { get "/categories", headers: headers}
      it 'should get all categories' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
    

    # get single category details
    context 'GET get single category details' do
      before { get "/categories/1", headers: headers}
      it 'should get single category details' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end

    # get department categories
    context 'GET get department categories' do
      before { get "/categories/inDepartment/1", headers: headers}
      it 'should get department categories' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end

  end
end
