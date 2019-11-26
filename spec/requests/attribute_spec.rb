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
    

    
  end
end
