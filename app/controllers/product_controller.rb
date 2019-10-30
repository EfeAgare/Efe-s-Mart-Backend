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
    
    json_response({ paginationMeta: {
      currentPage: params[:page].to_i,                # Current page number
      currentPageSize: params[:limit],        # The page limit
      totalPages: products.total_pages,               # The total number of pages for all products
      totalRecord: Product.count,               # The total number of product in the database
    }, rows: products } )
  end

  # get single product details
  def get_product
    products = Product.find(params[:product_id]);
    json_response(products)
  end

  # search all products
  def search_product
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get all products in a category
  def get_products_by_category
    json_response({ message: 'NOT IMPLEMENTED' })
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
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get all categories
  def get_all_categories
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get single category details
  def get_category
    json_response({ message: 'NOT IMPLEMENTED' })
  end

  # get all categories in a department
  def get_department_categories
    json_response({ message: 'NOT IMPLEMENTED' })
  end
end
