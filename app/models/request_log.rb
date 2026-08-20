class RequestLog < ApplicationRecord
  after_commit :cleanup_logs, on: :create

  private

  def cleanup_logs
    ids_to_keep = RequestLog.order(created_at: :desc).limit(100).pluck(:id)
    RequestLog.where.not(id: ids_to_keep).delete_all
  end
end