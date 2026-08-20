class ProcessKnowledgeFeedbackJob < ApplicationJob
  queue_as :default

  def perform(ai_reply, customer_question)
    block = ai_reply[/<knowledge_feedback>(.*?)<\/knowledge_feedback>/m, 1]

    return unless block.present?

    title =
      block[/title:\s*(.+)/i, 1]&.strip

    type =
      block[/type:\s*(.+)/i, 1]&.strip

    priority =
      block[/priority:\s*(.+)/i, 1]&.strip

    recommendation =
      block[/recommendation:\s*(.+)/i, 1]&.strip

    feedback = KnowledgeFeedback.find_or_initialize_by(
      title: title,
      feedback_type: type
    )

    if feedback.persisted?
      feedback.increment(:occurrences)
    else
      feedback.question = customer_question
      feedback.priority = priority
      feedback.recommendation = recommendation
      feedback.status = "pending"
      feedback.source = "WhatsApp AI"
    end

    feedback.save!
  end
end