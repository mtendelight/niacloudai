# config/initializers/recurring_tasks.rb

module RecurringTasks
  class << self
    def schedule_invoice_generation(client_id)
      # Logic to schedule invoice generation
      begin
        InvoiceGenerationJob.perform_later(client_id)
        Rails.logger.info "Invoice generation scheduled for client with ID: #{client_id}"
      rescue => e
        Rails.logger.error "Failed to schedule invoice generation for client with ID: #{client_id}. Error: #{e.message}"
      end
      # Add any additional scheduling logic as needed
    end

    def schedule_statement_generation(client_id)
      # Logic to schedule statement generation
      begin
        StatementGenerationJob.perform_later(client_id)
        Rails.logger.info "Statement generation scheduled for client with ID: #{client_id}"
      rescue => e
        Rails.logger.error "Failed to schedule statement generation for client with ID: #{client_id}. Error: #{e.message}"
      end
      # Add any additional scheduling logic as needed
    end
  end
end
