require 'rails_helper'

RSpec.describe ShoppingCartController, type: :request do
  let(:user) { create(:customer) }
  let(:headers) { valid_headers }

  let(:item) do
    {
      "cart_id": "1",
      "product_id": 8,
      "attribute_value": "favoute",
      "quantity": 1
  }
  end

  let(:quantity) do
    {
      "quantity": 20
    }
  end

  item_id = ""

  after(:each) do
    user.destroy
  end

  describe 'ShoppingCart Controller' do

    # generate random unique id for cart identifier
    context 'GET get unique id' do
      before { get "/shoppingcart/generateUniqueId", headers: headers}
      it 'should get unique id' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
    
    # add item to existing cart with cart id
    context 'POST  add item to existing cart with cart id' do
      before { post "/shoppingcart/add", params: item.to_json,headers: headers}
      
      it 'should add item to existing cart with cart id ' do
        expect(response).to  have_http_status(200)
        item_id = json[0]["table"]["item_id"] || "4b690596-104a-11ea-8a07-0ea927c56ac2"
        expect(json).to_not be_nil
      end
    end


    # get all items in a shopping cart using cart id
    context 'GET  all items in a shopping cart using cart id' do
      before { get "/shoppingcart/1", params: item.to_json,headers: headers}
      it 'should all items in a shopping cart using cart id ' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end


    # update quantity of an item in a shopping cart
    context 'PUT update quantity of an item in a shopping cart' do
      before { put "/shoppingcart/update/#{item_id}", params: quantity.to_json,headers: headers}
      it 'should update quantity of an item in a shopping cart' do
        expect(response).to  have_http_status(200)
        expect(json).to_not be_nil
      end
    end
  end
end
