# app/jobs/invoice_generation_job.rb
class InvoiceGenerationJob < ApplicationJob
  queue_as :default

  def perform(client_id)
    client = Client.find(client_id)
    invoices = Invoice.previous_month.where(client_id: client_id)

    invoices.each do |invoice|
      # Example logic: create a new invoice record based on the previous month's data
      new_invoice = Invoice.new(
        client_id: client.id,
        amount: invoice.total_amount, # Use the total amount from the existing invoice
        date: invoice.date, # Use the original invoice date
        due_date: invoice.date + 30.days # Example: set due date 30 days from the invoice date
      )

      if new_invoice.save
        # Example: send notification or perform additional tasks
        puts "Invoice generated for #{client.name} - Invoice ID: #{new_invoice.id}"
      else
        puts "Failed to generate invoice for #{client.name}"
      end
    end
  end
end
