class ImportPaymentsJob < ApplicationJob
  queue_as :default

  def perform(rows)
    SavePaymentsService.new(rows).call
  end
end