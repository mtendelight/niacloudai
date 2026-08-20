
class JmproductsController < ApplicationController

  def index

    @products = Jstock
                  .select(
                    "
                      MIN(id) AS id,
                      bale_name,
                      COALESCE(SUM(qty), 0) AS total_qty,
                      COALESCE(MAX(selling_price), 0) AS selling_price,
                      MAX(pieces_range) AS pieces_range,
                      MAX(description) AS description,
                      COUNT(DISTINCT branch) AS branches_count
                    "
                  )
                  .group(:bale_name)
              

    # SEARCH
    if params[:search].present?

      search = "%#{params[:search].strip}%"

      @products = @products.where(
        "
          bale_name ILIKE :search
        ",
        search: search
      )

    end

    # SORTING
    @products = @products.order("bale_name ASC")

    # TOTAL UNIQUE PRODUCTS
    @total_products = @products.size.count

    # TOTAL STOCK QTY
    @total_stock = @products.sum { |p| p.total_qty.to_i }

    # TOTAL INVENTORY VALUE
    @total_inventory_value = @products.sum do |p|
      p.total_qty.to_i * p.selling_price.to_i
    end

  end

end

