class JobApplicationsController < ApplicationController

  def create
    @application = JobApplication.new(application_params)

    if @application.save
      redirect_back fallback_location: openjobs_path,
                    notice: "Application submitted successfully"
    else
      redirect_back fallback_location: openjobs_path,
                    alert: @application.errors.full_messages.to_sentence
    end
  end

  def index
    @applications = JobApplication.includes(:talent, :openjob)
  end

  def update
    @application = JobApplication.find(params[:id])

    if @application.update(status: params[:status])
      redirect_back fallback_location: job_applications_path,
                    notice: "Status updated"
    else
      redirect_back fallback_location: job_applications_path,
                    alert: "Failed to update"
    end
  end

  private

  def application_params
    params.permit(:talent_id, :openjob_id, :status)
  end
end