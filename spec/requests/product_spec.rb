require "rails_helper"

RSpec.describe ProductController, type: :request do

  let(:user) { create(:customer) }
  let(:headers) { valid_headers }
  

  let(:search) do
    {
      "page": 6,
      "limit": 20, 
      "description_length": 34,                           
      "query_string": "This beautiful",   
      "all_words": "on"
   }
  end
  after(:each) do
    user.destroy
  end

  describe "ProductController" do


     # get all products
    context 'get all products' do
      before { get "/products", headers: headers } 

      it 'should return all product' do
        expect(response).to  have_http_status(200)
         expect(json).to_not be_nil  
      end

    end
    

    # get single product details
    context 'get single product details' do
      before { get "/products/25", headers: headers } 

      it 'should return single product details' do
        expect(response).to  have_http_status(200)
         expect(json).to_not be_nil  
      end

    end


    # search all products

    context 'get single product details' do
      before { get "/products/search", params: search ,headers: headers } 
      it 'should return single product details' do
        expect(response).to  have_http_status(200)
         expect(json).to_not be_nil  
      end
    end


     # get all products in a category
     context 'get all products in a category' do
      before { get "/products/inCategory/2" ,headers: headers } 
      it 'should return all products in a category' do
        expect(response).to  have_http_status(200)
         expect(json).to_not be_nil  
      end
    end

    # get all products in a department
    context 'get all products in a department' do
      before { get "/products/inDepartment/2" ,headers: headers } 
      it 'should return all products in a department' do
        expect(response).to  have_http_status(200)
         expect(json).to_not be_nil  
      end
    end

  end
end