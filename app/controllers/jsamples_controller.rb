class JsamplesController < ApplicationController
  before_action :set_jsample, only: %i[ show edit update destroy ]

  # GET /jsamples or /jsamples.json
  def index


        per_page = (params[:per_page] || 10).to_i

    # Eager load customers to avoid N+1
   @jsamples = Jsample.order(created_at: :desc)
                                  .page(params[:page])
                                  .per(per_page)
  end

  # GET /jsamples/1 or /jsamples/1.json
  def show
  end

  # GET /jsamples/new
  def new
    @jsample = Jsample.new
  end

  # GET /jsamples/1/edit
  def edit
  end

  # POST /jsamples or /jsamples.json
def create
  @jsample = Jsample.new(jsample_params)

  respond_to do |format|
    if @jsample.save
      format.html { redirect_to jsamples_path, notice: "Jsample was successfully created." }
      format.json { render :show, status: :created, location: @jsample }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @jsample.errors, status: :unprocessable_entity }
    end
  end
end


  # PATCH/PUT /jsamples/1 or /jsamples/1.json
  def update
    respond_to do |format|
      if @jsample.update(jsample_params)
        format.html { redirect_to @jsample, notice: "Jsample was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @jsample }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @jsample.errors, status: :unprocessable_entity }
      end
    end
  end


    def search
    if params[:q].blank? || params[:q].values.all?(&:blank?)
      @jsamples = Jsample.none.page(params[:page]).per(20)
      flash.now[:alert] = "No search criteria provided."
    else
      @f = Jsample.ransack(params[:q])
      @jsamples = @f.result.order(updated_at: :desc).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html
      format.csv { send_data @jmfulfillments.to_csv, filename: "customers-#{DateTime.now.strftime('%d%m%Y%H%M')}.csv" }
    end
  end

  # DELETE /jsamples/1 or /jsamples/1.json
  def destroy
    @jsample.destroy!

    respond_to do |format|
      format.html { redirect_to jsamples_path, notice: "Jsample was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jsample
      @jsample = Jsample.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def jsample_params
      params.require(:jsample).permit(:bale_name, :pieces_range, :description, :sample, :price_range, :video, :video_public_id)
    end
end
