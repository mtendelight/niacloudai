class OpinionMailer < ApplicationMailer
	def new_opinion(opinion)
    @opinion = opinion
    mail(to: "info@niapos.com", subject: "New Request Received")
  end
end
