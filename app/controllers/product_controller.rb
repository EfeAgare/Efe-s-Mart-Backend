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
    json_response({ message: 'NOT IMPLEMENTED' })
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
end
