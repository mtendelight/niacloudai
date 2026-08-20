class MsessionsController < ApplicationController
  before_action :set_msession, only: %i[ show edit update destroy ]
before_action :set_mbooking
  # GET /msessions or /msessions.json
def index
  @mbooking = Mbooking.find(params[:mbooking_id])
  @msessions = @mbooking.msessions
end

  # GET /msessions/1 or /msessions/1.json
  def show
  end

  # GET /msessions/new
 def new
  @mbooking = Mbooking.find(params[:mbooking_id])
  @msession = @mbooking.msessions.build
end

  # GET /msessions/1/edit
 def edit
  @mbooking = Mbooking.find(params[:mbooking_id])
  @msession = @mbooking.msessions.find(params[:id])
end

  # POST /msessions or /msessions.json
 def create
  @mbooking = Mbooking.find(params[:mbooking_id])
  @msession = @mbooking.msessions.build(msession_params)

  if @msession.save
    redirect_to mbooking_path(@mbooking), notice: "Session added successfully"
  else
    render :new
  end
end

# PATCH/PUT /mbookings/:mbooking_id/msessions/:id
def update
  respond_to do |format|
    if @msession.update(msession_params)

      format.html {
        redirect_to mbooking_msession_path(@mbooking, @msession),
        notice: "Session was successfully updated.",
        status: :see_other
      }

      format.json { render :show, status: :ok, location: [@mbooking, @msession] }

    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @msession.errors, status: :unprocessable_entity }
    end
  end
end

  # DELETE /msessions/1 or /msessions/1.json
  def destroy
    @msession.destroy!

    respond_to do |format|
      format.html { redirect_to msessions_path, notice: "Msession was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_msession
      @msession = Msession.find(params[:id])
    end

    def set_mbooking
  @mbooking = Mbooking.find(params[:mbooking_id])
end

   def msession_params
  params.require(:msession).permit(
    :session_number,
    :mbooking_id,
    :counsellor_id,
    :session_date,
    :start_time,
    :end_time,
    :duration_minutes,
    :presenting_issue,
    :session_notes,
    :intervention_used,
    :mood_before,
    :mood_after,
    :risk_level_after,
    :status,
    :is_final_session,
    :recommend_next_session,
    :paid,
    :payment_status,
    :amount_due,
    :amount_paid,
    :balance,
    :payment_method,
    :transaction_code,
    :payment_notes,
    :paid_at,
    :verified_by_id
  )
end
end
