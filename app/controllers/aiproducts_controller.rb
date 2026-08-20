class AiproductsController < ApplicationController
  require "roo"

def index
  @aiproducts = Aiproduct.order(:bale_name)

  if params[:search].present?
    search = "%#{params[:search].strip}%"

    @aiproducts = @aiproducts.where(
      "LOWER(bale_name) LIKE LOWER(?) OR LOWER(COALESCE(description, '')) LIKE LOWER(?)",
      search,
      search
    )
  end
end

  def import
    return redirect_to aiproducts_path,
      alert: "Please choose an Excel file." unless params[:file]

    spreadsheet =
      Roo::Spreadsheet.open(params[:file].path)

    sheet = spreadsheet.sheet(0)

    (2..sheet.last_row).each do |row|

      product =
        Aiproduct.find_or_initialize_by(
          bale_name: sheet.cell(row, 1).to_s.strip
        )

      product.description  = sheet.cell(row, 2)
      product.pieces_range = sheet.cell(row, 3)
      product.price        = sheet.cell(row, 4)

      product.save!
    end

    redirect_to aiproducts_path,
      notice: "Products imported successfully."

  rescue => e

    redirect_to aiproducts_path,
      alert: e.message
  end
end