require 'rails_helper'

RSpec.describe AttributeController, type: :request do
  let(:user) { create(:customer) }
  let(:headers) { valid_headers }

  after(:each) do
    user.destroy
  end

  describe 'Attribute Controller' do

    # get all attributes
    context 'GET get all attribute' do
      before { get "/attributes", headers: headers}
      it 'should get all attributes' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
    

    # get a single attribute using the attribute_id in the request parameter
    context 'GET get a single attribute' do
      before { get "/attributes/1", headers: headers}
      it 'should get a single attributes' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end

      # get all attribute values of a single attribute using the attribute id

      context 'GET all attribute values of a single attribute using the attribute id' do
        before { get "/attributes/values/1", headers: headers}
        it 'should get all attribute values of a single attribute using the attribute id' do
          expect(response).to  have_http_status(200)
          expect(json).to_not be_nil
        end
      end


  end
end
