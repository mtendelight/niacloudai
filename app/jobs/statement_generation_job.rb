# app/jobs/statement_generation_job.rb
class StatementGenerationJob < ApplicationJob
  queue_as :default

  def perform(client_id)
    client = Client.find(client_id)
    statement = Statement.previous_month.find_or_initialize_by(client_id: client_id)

    if statement.new_record?
      # Calculate the statement amount if a new record is being created
      amount_due = calculate_statement_amount(client)

      new_statement = Statement.new(
        client_id: client.id,
        amount_due: amount_due,
        start_date: 1.month.ago.beginning_of_month,
        end_date: 1.month.ago.end_of_month,
        generated_at: Time.zone.now
      )

      if new_statement.save
        # Log statement generation success
        Rails.logger.info "Statement generated for #{client.name} - Statement ID: #{new_statement.id}"
      else
        # Log statement generation failure
        Rails.logger.error "Failed to generate statement for #{client.name}: #{new_statement.errors.full_messages.to_sentence}"
      end
    else
      # Log if a statement already exists for the previous month
      Rails.logger.info "Statement already exists for #{client.name} for the previous month"
    end
  end

  private

  def calculate_statement_amount(client)
    # Example: Calculate the statement amount based on client's balance or other factors
    # Replace this with your actual logic to calculate the statement amount
    client.balance
  end
end
