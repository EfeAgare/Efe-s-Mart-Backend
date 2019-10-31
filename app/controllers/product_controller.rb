# The controller defined below is the product controller,
#
#  Some methods are stubbed out for you to implement them from scratch
# while others may contain one or two bugs
#
# NB: Check the BACKEND CHALLENGE TEMPLATE DOCUMENTATION linked in the readme of this repository
# to see our recommended endpoints, request body/param, and response object for each of these method

class ProductController < ApplicationController
  # get all products
  def get_all_products
    
    products = Product.page(params[:page]).per(params[:limit]);
    
    if !products.blank?
      json_response({ paginationMeta: {
        currentPage: params[:page].to_i,                # Current page number
        currentPageSize: params[:limit],        # The page limit
        totalPages: products.total_pages,               # The total number of pages for all products
        totalRecord: Product.count,               # The total number of product in the database
      }, rows: products } )
    else
      json_response({message: "Products not found"}, 404)
    end
    
  end

  # get single product details
  def get_product
    products = Product.find(params[:product_id]);
    json_response(products)
  end



  # search all products
  def search_product
    
    if !params[:query_string]
      json_response({error: {
        message: "params cannot be empty"
      }}, :bad_request)
    end

    if !params[:all_words]  || !params[:description_length] || !params[:limit] || !params[:page]
      params[:all_words]  = "on"
      params[:description_length] = 200
      params[:limit] = 20
      params[:page] = 1
    end
       
    search_product = StoredProcedureService.new.execute("catalog_search", "'#{params[:query_string]}','#{params[:all_words]}', '#{params[:description_length]}', '#{params[:limit]}', '#{params[:page]}'")

    json_response({rows: search_product.flatten })
  end

  # get all products in a category
  def get_products_by_category

    if !params[:description_length] || !params[:limit] || !params[:page]
      params[:description_length] = 200
      params[:limit] = 20
      params[:page] = 1
    end
       
    products_by_category = StoredProcedureService.new.execute("catalog_get_products_in_category", "'#{params[:category_id]}','#{params[:description_length]}', '#{params[:limit]}', '#{params[:page]}'")

    if !products_by_category.blank?
      json_response({rows: products_by_category })
    else
      json_response({message: "products in a category not found"}, 404)
    end
  end

  # get all products in a department
  def get_products_by_department
    if !params[:description_length] || !params[:limit] || !params[:page]
      params[:description_length] = 200
      params[:limit] = 20
      params[:page] = 1
    end
       
    products_by_department = StoredProcedureService.new.execute("catalog_get_products_on_department", "'#{params[:department_id]}','#{params[:description_length]}', '#{params[:limit]}', '#{params[:page]}'")

    if !products_by_department.blank?
      json_response({rows: products_by_department })
    else
      json_response({message: "products in a department not found"}, 404)
    end
  end

  # get all departments
  def get_all_departments
    departments = Department.all();
    json_response(departments)
  end

  # get single department details
  def get_department
    department = Department.find(params[:department_id])
    if !department.blank?
      json_response(department)
    else
      json_response({message: "department not found"}, 404)
    end
  end

  # get all categories
  def get_all_categories
    categories = Category.all()
    json_response(categories)
  end

  # get single category details
  def get_category
    category = Category.find(params[:category_id])
    if !category.blank?
      json_response(category)
    else
      json_response({message: "category not found"}, 404)
    end
  end

  # get all categories in a department
  def get_department_categories
    category_in_department = Category.where("department_id = ? ", params[:department_id])
    if !category_in_department.blank?
      json_response(category_in_department)
    else
      json_response({message: "category in department not found"}, 404)
    end
  end

  # get product details
  def get_product_details
    
  end

  # get product location
  def get_product_location
    
  end

  # create product review
  def create_product_reviews

    if !params[:product_id] || !params[:review] || !params[:rating]
      json_response({message: "params cannot be empty"}, 404)
    else
      review = Review.new({ product_id: params[:product_id].to_i,
                            review: params[:review],
                            rating: params[:rating].to_i,
                            customer_id: @current_user.customer_id
                            })

      if review.save!
        json_response(review)
      else
        json_response({message: "An error occur"}, 500)
      end
    end
  end

  # get product review 
  def get_product_reviews
    product_reviews = Review.where("product_id = ? ",params[:product_id])

    if !product_reviews.blank?
      json_response(product_reviews)
    else
      json_response({message: "No reviews for this product"}, 404)
    end
  end


  private

  def review_params
    params.permit(:product_id, :review, :rating)
  end
end
