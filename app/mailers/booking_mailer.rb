class BookingMailer < ApplicationMailer
  default from: "chat@momakgroup.co.ke"

  def new_booking_notification(recipients, booking)
    @booking = booking
    @adventure = booking.m_adventure

    mail(
      to: recipients,
      subject: "New Adventure Booking - #{@booking.name}"
    )
  end
end