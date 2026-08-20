class JanomaxesController < ApplicationController
  before_action :set_janomax, only: %i[ show edit update destroy ]
  
before_action :authenticate_user!, only: [:new, :edit]

    # GET /polling_infos or /polling_infos.json
def index
  # Pagination
  per_page = (params[:per_page] || 10).to_i
  @janomaxes = Janomax.all.order(created_at: :asc).page(params[:page]).per(per_page)
  @all_janomaxes = Janomax.all.order(created_at: :asc) # for CSV/XLSX export

  respond_to do |format|
    format.html # default HTML response

    # CSV export
    format.csv do
      send_data Janomax.to_csv({}, @all_janomaxes),
                filename: "janomaxbales-#{Date.today}.csv"
    end

    # XLSX export (inline, no template)
    format.xlsx do
      package = Axlsx::Package.new
      workbook = package.workbook
      workbook.add_worksheet(name: "Janomax Bales") do |sheet|
        sheet.add_row ["Item Name", "Pieces", "Price"]
        @all_janomaxes.each do |bale|
  sheet.add_row [
    bale.item_name,
    bale.pieces,
    bale.selling_price
  ]
end
      end
      send_data package.to_stream.read,
                filename: "janomaxbales-#{Date.today}.xlsx",
                type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    end

    format.js # for AJAX requests
  end
end

def search
  # Check if search parameters are blank
  if params[:q].blank? || params[:q].values.all?(&:blank?)
    @janomaxes = Janomax.none.page(params[:page]).per(10)
    flash.now[:alert] = "No search criteria provided."
  else
    @j = Janomax.ransack(params[:q])
    @janomaxes = @j.result.order(updated_at: :desc).page(params[:page]).per(10)
  end

  respond_to do |format|
    format.html # Renders the search view (make sure you have this view set up)
    format.csv { send_data @janomaxes.to_csv, filename: "bales-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
  end
end



  # GET /janomaxes/1 or /janomaxes/1.json
  def show
  end


    def import

  Janomax.import(params[:file])
  redirect_to janomaxes_path, notice: "Janomax Premium Bales imported successfully."
end

  # GET /janomaxes/new
  def new
    @janomax = Janomax.new
  end

  # GET /janomaxes/1/edit
  def edit
  end

  # POST /janomaxes or /janomaxes.json
  def create
    @janomax = Janomax.new(janomax_params)

    respond_to do |format|
      if @janomax.save
        format.html { redirect_to @janomax, notice: "Janomax was successfully created." }
        format.json { render :show, status: :created, location: @janomax }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @janomax.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /janomaxes/1 or /janomaxes/1.json
  def update
    respond_to do |format|
      if @janomax.update(janomax_params)
        format.html { redirect_to @janomax, notice: "Janomax was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @janomax }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @janomax.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /janomaxes/1 or /janomaxes/1.json
  def destroy
    @janomax.destroy!

    respond_to do |format|
      format.html { redirect_to janomaxes_path, notice: "Janomax was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_janomax
      @janomax = Janomax.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def janomax_params
      params.require(:janomax).permit(:item_name, :item_description, :pieces, :sample, :selling_price)
    end
end
