 Rails.application.routes.draw do
  get "/", to: "application#welcome"
  scope 'attributes' do
    get "/", to: "attribute#get_all_attributes"
    get "/:attribute_id", to: "attribute#get_single_attribute"
    get "/values/:attribute_id", to: "attribute#get_attribute_values"
    get "/inProduct/:product_id", to: "attribute#get_product_attributes"
  end

  scope 'customers' do
    post "/", to: "customer#update_credit_card"
    post "/login", to: "customer#login"
    post "/signup", to: "customer#create"
  end

  scope 'customer' do
    get "/", to: "customer#get_customer_profile"
    put "/", to: "customer#update_customer_profile"
    put "/address", to: "customer#update_customer_address"
    put "/creditCard", to: "customer#update_credit_card"
  end

  scope 'products' do
    get "/", to: "product#get_all_products"
    get "/search", to: "product#search_product"
    get "/:product_id/details", to: "product#get_product_details"
    get "/::product_id/locations", to: "product#get_product_location"
    post "/:product_id/reviews", to: "product#create_product_reviews"
    get "/:product_id/reviews", to: "product#get_product_reviews"
    get "/:product_id", to: "product#get_product"
    get "/inCategory/:category_id", to: "product#get_products_by_category"
    get "/inDepartment/:department_id", to: "product#get_products_by_department"
  end

  scope 'departments' do
    get "/", to: "product#get_all_departments"
    get "/:department_id", to: "product#get_department"
  end

  scope 'categories' do
    get "/", to: "product#get_all_categories"
    get "/:category_id", to: "product#get_category"
    get "/inDepartment/:department_id", to: "product#get_department_categories"
  end

  scope 'shipping' do
    get "/regions", to: "shipping#get_shipping_regions"
    get "/regions/:shipping_region_id", to: "shipping#get_shipping_type"
  end

  scope 'shoppingcart' do
    get "/generateUniqueId", to: "shopping_cart#generate_unique_cart"
    post "/add", to: "shopping_cart#add_item_to_cart"
    get "/:cart_id", to: "shopping_cart#get_cart"
    put "/update/:item_id", to: "shopping_cart#update_cart_item"
    delete "/empty/:cart_id", to: "shopping_cart#empty_cart"
    delete "/removeProduct/:item_id", to: "shopping_cart#remove_item_from_cart"
  end

  scope 'orders' do
    post "/", to: "shopping_cart#create_order"
    get "/inCustomer", to: "shopping_cart#get_customer_orders"
    get "/:order_id", to: "shopping_cart#get_order_summary"
  end

  post "/stripe/charge", to: "shopping_cart#process_stripe_payment"

  scope 'tax' do
    get "/", to: "tax#get_all_tax"
    get "/:tax_id", to: "tax#get_single_tax"
  end

end
