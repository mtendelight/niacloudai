class MPayment < ApplicationRecord
  belongs_to :m_subcontractor
  belongs_to :m_invoice
  has_one :m_approval, as: :approvable, dependent: :destroy
   mount_uploader :file, PermitPdfUploader

     after_create :create_pending_approval

  private

  def create_pending_approval
    create_m_approval(status: "pending")
  end
end