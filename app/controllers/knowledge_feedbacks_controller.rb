# app/controllers/knowledge_feedbacks_controller.rb

class KnowledgeFeedbacksController < ApplicationController
  def index
    per_page = params[:per_page].presence.to_i
    per_page = 5 if per_page.zero?

    @knowledge_feedbacks = KnowledgeFeedback.all

    # Search
    if params[:q].present?
      q = "%#{params[:q].strip}%"

      @knowledge_feedbacks = @knowledge_feedbacks.where(
        "title ILIKE :q
         OR question ILIKE :q
         OR recommendation ILIKE :q",
        q: q
      )
    end

    # Filter by type
    if params[:feedback_type].present?
      @knowledge_feedbacks =
        @knowledge_feedbacks.where(feedback_type: params[:feedback_type])
    end

    # Filter by priority
    if params[:priority].present?
      @knowledge_feedbacks =
        @knowledge_feedbacks.where(priority: params[:priority])
    end

    # Filter by status
    if params[:status].present?
      @knowledge_feedbacks =
        @knowledge_feedbacks.where(status: params[:status])
    end

    @knowledge_feedbacks = @knowledge_feedbacks
      .order(occurrences: :desc, created_at: :desc)
      .page(params[:page])
      .per(per_page)
  end

  def show
    @knowledge_feedback = KnowledgeFeedback.find(params[:id])
  end
end