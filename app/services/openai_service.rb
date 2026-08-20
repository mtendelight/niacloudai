class OpenaiService
  def initialize(conversation = nil, history: nil, user_message: nil, current_user: nil)
    @conversation = conversation
    @history = history
    @user_message = user_message
    @current_user = current_user
  end

  def reply
    client = OpenAI::Client.new(
      access_token: ENV.fetch("OPENAI_API_KEY")
    )

    if @conversation.present?
      # WhatsApp conversation

      @user_message = @conversation
                        .aimessages
                        .where(role: "user")
                        .last
                        &.content
                        .to_s

      history = @conversation
                  .aimessages
                  .order(:created_at)
                  .last(20)
                  .map do |m|
        {
          role: m.role,
          content: m.content
        }
      end

    else
      # Internal AI chat

      history = @history || []
      @user_message ||= history.last&.dig(:content).to_s
    end

    products = KnowledgeService.products(@user_message)
    faqs     = KnowledgeService.faqs(@user_message)
    samples  = KnowledgeService.samples(@user_message)

    messages = [
      {
        role: "system",
        content: PromptService.system_prompt(
          products,
          faqs,
          samples
        )
      }
    ]

    history.each do |message|
      messages << {
        role: message[:role],
        content: message[:content]
      }
    end

    response = client.chat(
      parameters: {
        model: "gpt-5-nano",
        messages: messages
      }
    )

    reply = response
              .dig("choices", 0, "message", "content")
              .to_s
              .strip

    ProcessKnowledgeFeedbackJob.perform_later(
      reply,
      @user_message
    )

    reply.gsub!(
      /<knowledge_feedback>.*?<\/knowledge_feedback>/m,
      ""
    )

    reply.strip!

    reply.presence ||
      "I'll connect you with one of our team members."

  rescue => e
    Rails.logger.error("[OpenAI] #{e.class}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))

    "Sorry, I'm having trouble responding right now. Please try again shortly."
  end
end