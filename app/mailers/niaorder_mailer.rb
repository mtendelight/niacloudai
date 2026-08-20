class NiaorderMailer < ApplicationMailer
  default from: "chats@momakgroup.co.ke"

  def new_order_notification(recipients, order)
    @order = order

    mail(
      to: recipients,
      subject: "🛒 New Order ##{@order.id} - #{@order.customer_name}"
    )
  end
end