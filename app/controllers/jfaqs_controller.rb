class JfaqsController < ApplicationController
  before_action :set_jfaq, only: %i[ show edit update destroy ]

  # GET /jfaqs or /jfaqs.json
def index
  @jfaqs = if params[:q].present?
    Jfaq.where("question ILIKE ? OR answer ILIKE ? OR category ILIKE ?",
               "%#{params[:q]}%",
               "%#{params[:q]}%",
               "%#{params[:q]}%")
  else
    Jfaq.all
  end
end

  # GET /jfaqs/1 or /jfaqs/1.json
  def show
  end

  # GET /jfaqs/new
  def new
    @jfaq = Jfaq.new
  end

  # GET /jfaqs/1/edit
  def edit
  end

  # POST /jfaqs or /jfaqs.json
def create
  @jfaq = Jfaq.new(jfaq_params)

  respond_to do |format|
    if @jfaq.save
      format.html { redirect_to jfaqs_path, notice: "Jfaq was successfully created." }
      format.json { render :show, status: :created, location: @jfaq }
    else
      format.html { render :new, status: :unprocessable_content }
      format.json { render json: @jfaq.errors, status: :unprocessable_content }
    end
  end
end

# PATCH/PUT /jfaqs/1 or /jfaqs/1.json
def update
  respond_to do |format|
    if @jfaq.update(jfaq_params)
      format.html do
        redirect_to jfaqs_path,
                    notice: "FAQ was successfully updated.",
                    status: :see_other
      end
      format.json { render :show, status: :ok, location: @jfaq }
    else
      format.html { render :edit, status: :unprocessable_content }
      format.json { render json: @jfaq.errors, status: :unprocessable_content }
    end
  end
end
  # DELETE /jfaqs/1 or /jfaqs/1.json
  def destroy
    @jfaq.destroy!

    respond_to do |format|
      format.html { redirect_to jfaqs_path, notice: "Jfaq was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jfaq
      @jfaq = Jfaq.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def jfaq_params
      params.expect(jfaq: [ :question, :answer, :category ])
    end
end
