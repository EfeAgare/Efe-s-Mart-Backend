require 'rails_helper'

RSpec.describe ProductController, type: :request do
  let(:user) { create(:customer) }
  let(:headers) { valid_headers }

  after(:each) do
    user.destroy
  end

  describe 'Product Controller' do

    # get all departments
    context 'GET get all departments' do
      before { get "/departments", headers: headers}
      it 'should get all departments' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
    

    # get single department details
    context 'GET get a single attribute' do
      before { get "/departments/1", headers: headers}
      it 'should get a single departments' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end

  end
end
