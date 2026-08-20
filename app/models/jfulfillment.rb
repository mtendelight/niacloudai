class Jfulfillment < ApplicationRecord
  belongs_to :jmcustomer, optional: true
 has_paper_trail
  audited

  before_create :ensure_created_from_payment
 before_save :auto_mark_delivered

def ensure_created_from_payment
  throw(:abort) if Thread.current[:skip_fulfillment]
end


    def self.ransackable_attributes(auth_object = nil)
    %w[name phone location]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end


    # Validations for mandatory fields based on status

enum :issue_status, { 
  pending: "pending", 
  resolved: "resolved"},suffix: true


enum :status, {
  pending: "Pending",
  dispatched: "Dispatched",
  delivered: "Delivered",
  refund_cancelled: "Refund/Cancelled",
  refunded: "Refunded"
}, suffix: true

  validates :name, :phone, :location, :items, presence: true

  before_validation :set_default_status, on: :create
  validate :feedback_and_comments_required_on_update, on: :update
  private

  def set_default_status
    self.status ||= "Pending"
  end

  
def auto_mark_delivered
  return unless status.present?

  if status.in?(["Pending", "Dispatched"])
    self.status = "Delivered"
  end
end


  def feedback_and_comments_required_on_update
    # Compare current value with the original DB value
    if status_changed_to_mandatory?
      errors.add(:feedback, "must be provided when status is Delivered or Refund/Cancelled") if feedback.blank?
      errors.add(:comments, "must be provided when status is Delivered or Refund/Cancelled") if comments.blank?
    end
  end

  # Check if status is now delivered or refund_cancelled
 def status_changed_to_mandatory?
  will_save_change_to_status? &&
    %w[delivered refunded refund_cancelled].include?(status)
end


def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
   when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
   when '.xls' then Roo::Excel.new(file.path )
   when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore)
   else raise "Unknown file type: #{file.original_filename}"
  end
end

end
